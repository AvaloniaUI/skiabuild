LAYER:=skia
include $(DEFINE_LAYER)

SKIA_GIT_REF?=main

skia:=$(LSTAMP)/skia
skia_sync_deps:=$(LSTAMP)/skia_sync_deps
skia_config:=$(LSTAMP)/skia_config
skia_install:=$(LSTAMP)/skia_install
skia_pkgconfig:=$(SYSROOT)/$(PREFIX)/$(LIBDIR)/pkgconfig/skia.pc

$(call git_clone, skia, https://github.com/google/skia.git, $(SKIA_GIT_REF))

$(L) += $(skia_sync_deps)
$(L) += $(skia_config)
$(L) += $(skia)
$(L) += $(skia_install)
$(L) += $(skia_pkgconfig)


DEPENDS += fontconfig


include $(BUILD_LAYER)

SKIA_ARCH=x86_64

$(skia_sync_deps):
	cd $(srcdir)/skia && ./tools/git-sync-deps
	$(stamp)

SKIA_ARGS:=
SKIA_ARGS += is_official_build=true
SKIA_ARGS += skia_enable_tools=false
SKIA_ARGS += extra_cflags=[\"-I$(SYSROOT)/$(PREFIX)/include\"]
SKIA_ARGS += extra_ldflags=[\"-L$(SYSROOT)/$(PREFIX)/$(LIBDIR)\", \"-static-libstdc++\", \"-static-libgcc\" ]
SKIA_ARGS += target_os=\"linux\" target_cpu=\"$(SKIA_ARCH)\"
SKIA_ARGS += skia_use_icu=false
SKIA_ARGS += skia_use_sfntly=false
SKIA_ARGS += skia_use_piex=true
SKIA_ARGS += skia_use_system_expat=false
SKIA_ARGS += skia_use_system_freetype2=false
SKIA_ARGS += skia_use_system_libjpeg_turbo=false
SKIA_ARGS += skia_use_system_libpng=false
SKIA_ARGS += skia_use_system_libwebp=false
SKIA_ARGS += skia_use_system_zlib=false
SKIA_ARGS += skia_use_x11=false
SKIA_ARGS += skia_enable_gpu=true
SKIA_ARGS += cc=\"$(CLANG)\"
SKIA_ARGS += cxx=\"$(CLANGXX)\"
SKIA_ARGS += ar=\"$(AR)\"

$(skia_config): $(skia_sync_deps)
	cd $(srcdir)/skia && gn gen $(builddir)/skia --args="$(SKIA_ARGS)"
	$(stamp)

$(skia): $(skia_config)
	cd $(builddir)/skia && ninja $(BUILD_JOBS)
	$(stamp)

$(skia_install): $(skia)
	mkdir -p $(SYSROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/include/skia
	mkdir -p $(PKGROOT)/$(PREFIX)/$(LIBDIR)
	cp -rv $(srcdir)/skia/include $(SYSROOT)/$(PREFIX)/include/skia
	cp -rv $(srcdir)/skia/include $(PKGROOT)/$(PREFIX)/include/skia
	cp $(builddir)/skia/libskia.a $(SYSROOT)/$(PREFIX)/$(LIBDIR)/
	cp $(builddir)/skia/libskia.a $(PKGROOT)/$(PREFIX)/$(LIBDIR)/
	$(stamp)

$(skia_pkgconfig): $(skia_install)
	cp $(BASE_skia)/skia.pc.in $@

$(L).clean:
	rm -rf $(builddir)
