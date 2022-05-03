SKIA_ARGS += target_os=\"macos\"
SKIA_ARGS += extra_cflags=[ \"-DHAVE_ARC4RANDOM_BUF\", \"-stdlib=libc++\" ]
SKIA_ARGS += extra_ldflags=[\"-stdlib=libc++\" ]

SKIA_ARGS += skia_use_icu=false
SKIA_ARGS += skia_use_sfntly=false
SKIA_ARGS += skia_use_metal=true
SKIA_ARGS += skia_use_piex=true
SKIA_ARGS += skia_use_system_expat=false
SKIA_ARGS += skia_use_system_libjpeg_turbo=false
SKIA_ARGS += skia_use_system_libpng=false
SKIA_ARGS += skia_use_system_libwebp=false
SKIA_ARGS += skia_use_system_zlib=false
SKIA_ARGS += skia_use_x11=false
SKIA_ARGS += skia_enable_gpu=true
SKIA_ARGS += cc=\"$(SKIA_CC)\"
SKIA_ARGS += cxx=\"$(SKIA_CXX)\"
SKIA_ARGS += ar=\"$(SKIA_AR)\"

