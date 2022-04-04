include $(DEFINE_RECIPE)
SYSROOT?=$(OUT)/sysroot

ifeq ($(CC),cc)
export CC:=gcc-10
export CXX:=g++-10
endif

HOST:=$(shell $(CC) -dumpmachine)

PREFIX:=usr/local
LIBDIR:=lib

ifeq ($(HOST),x86_64-linux-gnu)
LIBDIR:=lib64
endif

export LIBRARY_PATH="$(SYSROOT)/$(PREFIX)/$(LIBDIR):$(SYSROOT)/usr/lib64"

ifneq ($(shell which distcc 2> /dev/null),)
export DISTCC_HOSTS=10.1.0.16/4 10.1.0.24/32 10.1.0.40/20 10.1.0.48/16
export CC:=distcc $(CC)
export CXX:=distcc $(CXX)
endif

ifneq ($(shell which distcc 2> /dev/null),)
ifdef DISTCC_HOSTS
BUILD_JOBS=-j $$(distcc -j)
testy:
	echo $(BUILD_JOBS)

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

