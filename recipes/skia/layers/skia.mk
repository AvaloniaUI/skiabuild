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

ifdef WINDOWS
SKIA_ARCH:=x64
else
SKIA_ARCH:=x86_64
endif

$(skia_sync_deps):
	cd $(srcdir)/skia && python3 ./tools/git-sync-deps
	$(stamp)

SKIA_ARGS:=
SKIA_ARGS += is_official_build=true
SKIA_ARGS += skia_enable_tools=false
SKIA_ARGS += target_cpu=\"$(SKIA_ARCH)\"
ifndef WINDOWS
SKIA_ARGS += target_os=\"linux\"
SKIA_ARGS += extra_cflags=[\"-I$(SYSROOT)/$(PREFIX)/include\"]
SKIA_ARGS += extra_ldflags=[\"-L$(SYSROOT)/$(PREFIX)/$(LIBDIR)\", \"-static-libstdc++\", \"-static-libgcc\" ]
else
SKIA_ARGS += target_os=\"win\"
SKIA_ARGS += skia_use_dng_sdk=true
SKIA_ARGS += skia_enable_fontmgr_win_gdi=false
SKIA_ARGS += extra_cflags=[ \"-D_HAS_AUTO_PTR_ETC=1\" ] 
endif

SKIA_ARGS += skia_use_icu=false
SKIA_ARGS += skia_use_sfntly=false
SKIA_ARGS += skia_use_piex=true
SKIA_ARGS += skia_use_system_expat=false
ifndef WINDOWS
SKIA_ARGS += skia_use_system_freetype2=false
endif
SKIA_ARGS += skia_use_system_libjpeg_turbo=false
SKIA_ARGS += skia_use_system_libpng=false
SKIA_ARGS += skia_use_system_libwebp=false
SKIA_ARGS += skia_use_system_zlib=false
SKIA_ARGS += skia_use_x11=false
SKIA_ARGS += skia_enable_gpu=true
ifndef WINDOWS
SKIA_ARGS += skia_use_vulkan=true
SKIA_ARGS += cc=\"$(CLANG)\"
SKIA_ARGS += cxx=\"$(CLANGXX)\"
SKIA_ARGS += ar=\"$(AR)\"
endif
ifdef WINDOWS
SKIA_ARGS += clang_win=\"c:\Program Files\LLVM\"
endif

GN:=gn

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
