LAYER:=skia
include $(DEFINE_LAYER)

SKIA_GIT_REF?=main

skia:=$(LSTAMP)/skia
skia_sync_deps:=$(LSTAMP)/skia_sync_deps
skia_config:=$(LSTAMP)/skia_config
skia_describe:=$(BUILD)/$(L)/skia_defines.txt
skia_install:=$(LSTAMP)/skia_install

ifeq ($(CONFIG_SKIA_EMBEDDED_FONTS),y)
skia_embedded_fonts:=$(LSTAMP)/skia_embedded_fonts
endif

ifndef WINDOWS
skia_pkgconfig:=$(SYSROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig/skia.pc $(PKGROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig/skia.pc
endif

skia_cmake:=$(PKGROOT)/skia.cmake

$(call git_clone, skia, https://github.com/google/skia.git, $(SKIA_GIT_REF))

$(L) += $(skia_sync_deps)
$(L) += $(skia_config)
$(L) += $(skia_describe)
$(L) += $(skia)
ifeq ($(CONFIG_SKIA_EMBEDDED_FONTS),y)
$(L) += $(skia_embedded_fonts)
endif
$(L) += $(skia_install)
$(L) += $(skia_pkgconfig)
$(L) += $(skia_cmake)


DEPENDS += fontconfig


include $(BUILD_LAYER)

SKIA_ARCH?=x86_64
SKIA_CC?=$(CLANG)
SKIA_CXX?=$(CLANGXX)
SKIA_AR?=$(AR)

$(skia_sync_deps):
	cd $(srcdir)/skia && python3 ./tools/git-sync-deps
	$(stamp)

SKIA_ARGS += skia_enable_tools=false

include $(RECIPE)/skia-config-$(CONFIG_SKIACONFIG).mk

SKIA_ARGS += cc=\"$(SKIA_CC)\"
SKIA_ARGS += cxx=\"$(SKIA_CXX)\"
SKIA_ARGS += ar=\"$(SKIA_AR)\"

GN?=gn

ifdef WINDOWS
GN:=./bin/gn
endif

TC_SOURCE:=

ifeq ($(CONFIG_VARIANT),wasm)
TC_SOURCE=source $(srcdir)/skia/third_party/externals/emsdk/emsdk_env.sh &&
SKIA_TARGET:=libskia.a
endif

$(skia_config): $(skia_sync_deps)
	cd $(srcdir)/skia && $(TC_SOURCE) $(GN) gen $(builddir)/skia --args="$(SKIA_ARGS)"
	$(stamp)

.PHONY: gn_desc
gn_desc: $(skia_describe)

$(skia_describe):
	mkdir -p $(dir $@)
	cd $(srcdir)/skia && $(TC_SOURCE) $(GN) desc $(builddir)/skia :skia defines > $@


$(skia): $(skia_config)
	cd $(builddir)/skia && ninja $(BUILD_JOBS) $(SKIA_TARGET)
	$(stamp)

ifeq ($(CONFIG_SKIA_EMBEDDED_FONTS),y)
$(skia_embedded_fonts): $(skia)
	mkdir -p $(builddir)/merge-dir
	cd $(builddir)/merge-dir && $(TC_SOURCE) for file in $$(ls $(builddir)/skia/*.a) ; do \
		$(SKIA_AR) x $$file ; \
	done

	cd $(builddir)/skia && $(srcdir)/skia/tools/embed_resources.py --name SK_EMBEDDED_FONTS --input $(srcdir)/skia/modules/canvaskit/fonts/NotoMono-Regular.ttf --output $(builddir)/font.cpp --align 4
	cd $(builddir)/merge-dir && $(TC_SOURCE) $(SKIA_CXX) -std=c++17 -I. $(builddir)/font.cpp -r -o $(builddir)/merge-dir/font.o

	$(TC_SOURCE) $(SKIA_AR) -crs $(builddir)/skia/libskia.a $(builddir)/merge-dir/*.o

	cd $(builddir)/skia && $(TC_SOURCE) ninja skia_c_api_example
	$(stamp)
endif

$(skia_install): $(skia) $(skia_embedded_fonts)
ifndef WINDOWS
	mkdir -p $(SYSROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/include/skia
	mkdir -p $(SYSROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig
	mkdir -p $(PKGROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig
	cp -rv $(srcdir)/skia/include $(SYSROOT)/$(PREFIX)/include/skia
	cp -rv $(srcdir)/skia/include $(PKGROOT)/$(PREFIX)/include/skia
	cp $(builddir)/skia/libskia.a $(SYSROOT)/$(PREFIX)/$(LIBDIR)/
	cp $(builddir)/skia/libskia.a $(PKGROOT)/$(PREFIX)/$(LIBDIR)/
else
	mkdir -p $(PKGROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/$(LIBDIR)
	cp -rv $(srcdir)/skia/include $(PKGROOT)/$(PREFIX)/include/skia
	cp $(builddir)/skia/skia.lib $(PKGROOT)/$(PREFIX)/$(LIBDIR)/
	cp $(SYSROOT)/lib/libharfbuzz.a $(PKGROOT)/$(PREFIX)/$(LIBDIR)/
	cp -r $(SYSROOT)/include/harfbuzz $(PKGROOT)/$(PREFIX)/include/
endif
	$(stamp)

ifndef WINDOWS
$(skia_pkgconfig): $(skia_install)
	cp $(BASE_skia)/skia.pc.in $@
	for def in $(shell cat $(skia_describe)) ; do \
		sed -i "s/^Cflags:.*/& -D$${def}/" $@ ; \
	done

endif

$(skia_cmake): $(skia_install)
	cp $(BASE_skia)/skia.cmake.in $@
	echo "set(SKIA_PREFIX $(PREFIX))" > $@
	echo "set(SKIA_LIBDIR $(PREFIX)/lib64)" >> $@
	for def in $(shell cat $(skia_describe)) ; do \
		echo "list(APPEND SKIA_COMPILE_DEFINES -D$${def})" >> $@ ; \
	done


$(L).clean:
	rm -rf $(builddir)
