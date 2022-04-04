# SkiaBuild
[![Build Skia x-plat](https://github.com/AvaloniaUI/Avalonia.Skia/actions/workflows/skiabuild.yml/badge.svg?branch=main)](https://github.com/AvaloniaUI/Avalonia.Skia/actions/workflows/skiabuild.yml)

Cross-platform meta build of skia for Avalonia

## Build System

The top-level build system is driven by a Make based tool called [ve-root](https://github.com/jameswalmsley/ve-root)
Described in a sentence: ve-root is a simplified version of bitbake / yocto for generating complex sysroots and root file-systems.

### How to Build libavalonia.skia for `x86_64-linux-gnu`

```bash
# Choose the build configuration being built
make skia_defconfig

# Enter the docker container (this should get pulled, as CI has built it for you).
make docker

# Build recipe
make

la -la out/skia
total 13520
drwxr-xr-x 1 james james       94 Apr  4 18:09 ./
drwxr-xr-x 1 james james        8 Apr  4 17:32 ../
-rw-r--r-- 1 james james      236 Apr  4 17:32 meson.toolchain
drwxr-xr-x 1 james james        6 Apr  4 17:33 sysroot/
-rw-r--r-- 1 james james 13835706 Apr  4 18:09 sysroot.tar.gz

ls -la out/skia/sysroot/usr/local/lib64
total 38724
drwxr-xr-x 1 james james      424 Apr  4 19:20 ./
drwxr-xr-x 1 james james       46 Apr  4 17:57 ../
-rwxr-xr-x 1 james james 10858032 Apr  4 19:20 libavalonia.skia.so*
-rw-r--r-- 1 james james 25665680 Apr  4 19:18 libskia.a
drwxr-xr-x 1 james james      104 Apr  4 19:18 pkgconfig/
```

### Build Variants

The main build variant (from `skia_defconfig`) is for `x86_64-linux-gnu`.
The other variants will be configured by:

```
make skia_aarch64-linux-gnu_defconfig
make skia_i686-linux-gnu_defconfig
make skia_x86_86-linux-alpine_defconfig

# etc etc
```

## libavalonia.skia

The main library sources for the avalonia.skia bindings library can be found under:
`libavalonia.skia`

Add sources to:
`meson.build`

etc.

Keeping the library within meson, built by ve-root will ensure everything gets built correctly
and consistently. 

Using the `make docker` command will enter the build container as your current user for development.
This means you can build your libraries within the docker build system, and then link to it on your
development host by linking to the output libraries / sysroot.



