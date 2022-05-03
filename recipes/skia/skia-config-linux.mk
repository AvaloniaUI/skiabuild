SKIA_ARGS += target_os=\"linux\"
SKIA_ARGS += extra_cflags=[\"-I$(SYSROOT)/$(PREFIX)/include\"]
SKIA_ARGS += extra_ldflags=[\"-L$(SYSROOT)/$(PREFIX)/$(LIBDIR)\", \"-static-libstdc++\", \"-static-libgcc\" ]

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
SKIA_ARGS += skia_use_vulkan=true
SKIA_ARGS += cc=\"$(SKIA_CC)\"
SKIA_ARGS += cxx=\"$(SKIA_CXX)\"
SKIA_ARGS += ar=\"$(SKIA_AR)\"

