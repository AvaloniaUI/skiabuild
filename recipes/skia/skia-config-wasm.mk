SKIA_ARGS += target_os=\"linux\"
SKIA_ARGS += target_cpu=\"wasm\"
# SKIA_ARGS += skia_enable_ccpr=false
SKIA_ARGS += skia_enable_fontmgr_custom_directory=false
SKIA_ARGS += skia_enable_fontmgr_custom_empty=false
SKIA_ARGS += skia_enable_fontmgr_custom_embedded=true
SKIA_ARGS += skia_enable_fontmgr_empty=false
SKIA_ARGS += skia_enable_gpu=true
SKIA_ARGS += skia_gl_standard=\"webgl\"
# SKIA_ARGS += skia_enable_nvpr=false
SKIA_ARGS += skia_enable_pdf=true
SKIA_ARGS += skia_use_dng_sdk=false
SKIA_ARGS += skia_use_webgl=true
SKIA_ARGS += skia_use_fontconfig=false
SKIA_ARGS += skia_use_freetype=true
SKIA_ARGS += skia_use_harfbuzz=false
SKIA_ARGS += skia_use_icu=false
SKIA_ARGS += skia_use_piex=false
SKIA_ARGS += skia_use_sfntly=false
# SKIA_ARGS += skia_use_system_expat=false
SKIA_ARGS += skia_use_system_freetype2=false
SKIA_ARGS += skia_use_system_libjpeg_turbo=false
SKIA_ARGS += skia_use_system_libpng=false
SKIA_ARGS += skia_use_system_libwebp=false
SKIA_ARGS += skia_use_system_zlib=false
SKIA_ARGS += skia_use_vulkan=false
SKIA_ARGS += skia_use_wuffs=true
# SKIA_ARGS += use_PIC=false
SKIA_ARGS += extra_cflags=[
SKIA_ARGS +=   \"-DSKIA_C_DLL\", \"-DXML_POOR_ENTROPY\",
SKIA_ARGS +=   \"-DSKNX_NO_SIMD\", \"-DSK_DISABLE_AAA\", \"-DGR_GL_CHECK_ALLOC_WITH_GET_ERROR=0\",
SKIA_ARGS += ]
SKIA_ARGS += extra_cflags_cc=[ \"-frtti\" ]

