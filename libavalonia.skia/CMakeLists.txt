cmake_minimum_required(VERSION 3.20)
project(avalonia.skia)

find_package(PkgConfig)

set(ENV{PKG_CONFIG_DIR} "")
set(ENV{PKG_CONFIG_LIBDIR} "${PKGROOT}/usr/lib/pkgconfig:${PKGROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${PKGROOT})

pkg_check_modules(PKG_SKIA REQUIRED IMPORTED_TARGET skia)

add_library(avalonia.skia SHARED avalonia.skia.cpp)
target_include_directories(avalonia.skia PRIVATE ${PKG_SKIA_INCLUDE_DIRS})
target_link_libraries(avalonia.skia PRIVATE PkgConfig::PKG_SKIA)
target_link_options(avalonia.skia PRIVATE "-Wl,--version-script=${CMAKE_SOURCE_DIR}/libavalonia.skia.version")
target_link_options(avalonia.skia PRIVATE "-static-libgcc")
target_link_options(avalonia.skia PRIVATE "-static-libstdc++")
target_compile_options(avalonia.skia PRIVATE "-static-libstdc++")
target_compile_options(avalonia.skia PRIVATE "-static-libgcc")

add_executable(avalonia.skia.testprog testprog.c)

target_link_libraries(avalonia.skia.testprog PRIVATE avalonia.skia)


install(TARGETS avalonia.skia)
install(TARGETS avalonia.skia.testprog)
