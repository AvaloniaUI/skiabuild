include $(DEFINE_RECIPE)
SYSROOT?=$(OUT)/sysroot

ifeq ($(CC),cc)
ifneq ($(shell which gcc-10 2> /dev/null),)
export CC:=gcc-10
export CXX:=g++-10
endif
endif

CLANG?=clang-13
CLANGXX?=clang++-13

HOST:=$(shell $(CC) -dumpmachine)

PREFIX:=usr/local
LIBDIR:=lib

ifeq ($(HOST),x86_64-linux-gnu)
LIBDIR:=lib64
endif

export LIBRARY_PATH="$(SYSROOT)/$(PREFIX)/$(LIBDIR):$(SYSROOT)/usr/lib64"

ifneq ($(shell which distcc 2> /dev/null),)
ifdef DISTCC_HOSTS
export CC:=distcc $(CC)
export CXX:=distcc $(CXX)
export CLANG:=distcc $(CLANG)
export CLANGXX:=distcc $(CLANGXX)
BUILD_JOBS=-j $$(distcc -j)
endif
endif

MESON_OPTIONS:=

LAYERS += meson
LAYERS += freetype
LAYERS += fontconfig
LAYERS += skia
LAYERS += avalonia_skia
LAYERS += sysroot/package

include $(BUILD_RECIPE)

