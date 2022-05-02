LAYER:=skia
include $(DEFINE_LAYER)

SKIA_GIT_REF?=main

skia:=$(LSTAMP)/skia
skia_sync_deps:=$(LSTAMP)/skia_sync_deps
skia_config:=$(LSTAMP)/skia_config
skia_install:=$(LSTAMP)/skia_install

ifndef WINDOWS
skia_pkgconfig:=$(SYSROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig/skia.pc $(PKGROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig/skia.pc
endif

$(call git_clone, skia, https://github.com/google/skia.git, $(SKIA_GIT_REF))

$(L) += $(skia_sync_deps)
$(L) += $(skia_config)
$(L) += $(skia)
$(L) += $(skia_install)
$(L) += $(skia_pkgconfig)


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

$(skia_config): $(skia_sync_deps)
	cd $(srcdir)/skia && $(GN) gen $(builddir)/skia --args="$(SKIA_ARGS)"
	$(stamp)

$(skia): $(skia_config)
	cd $(builddir)/skia && ninja $(BUILD_JOBS)
	$(stamp)


$(skia_install): $(skia)
ifndef WINDOWS
	mkdir -p $(SYSROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/$(LIBDIR)
	mkdir -p $(PKGROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig
	cp -rv $(srcdir)/skia/include $(SYSROOT)/$(PREFIX)/include/skia
	cp -rv $(srcdir)/skia/include $(PKGROOT)/$(PREFIX)/include/skia
	cp $(builddir)/skia/libskia.a $(SYSROOT)/$(PREFIX)/$(LIBDIR)/
	cp $(builddir)/skia/libskia.a $(PKGROOT)/$(PREFIX)/$(LIBDIR)/
else
	mkdir -p $(PKGROOT)/include/skia
	cp -rv $(srcdir)/skia/include $(PKGROOT)/include/skia
	cp $(builddir)/skia/skia.lib $(PKGROOT)
endif
	$(stamp)

ifndef WINDOWS
$(skia_pkgconfig): $(skia_install)
	cp $(BASE_skia)/skia.pc.in $@
endif

$(L).clean:
	rm -rf $(builddir)
