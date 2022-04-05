LAYER:=avalonia_skia
include $(DEFINE_LAYER)

avalonia_toolchain_file:=$(SYSROOT)/cmake.toolchain
avalonia_skia:=$(LSTAMP)/avalonia.skia
avalonia_symbols:=$(PKGROOT)/libavalonia.skia.symbols
avalonia_lddtree:=$(PKGROOT)/libavalonia.skia.lddtree
avalonia_install:=$(LSTAMP)/avalonia_install

$(L) += $(avalonia_toolchain_file)
$(L) += $(avalonia_skia)
$(L) += $(avalonia_symbols)
$(L) += $(avalonia_lddtree)

DEPENDS += skia

include $(BUILD_LAYER)

$(L): $(BASE)/libavalonia.skia/meson.build

$(avalonia_toolchain_file):
	cp $(BASE_avalonia_skia)/cmake.toolchain.in $@
	sed -i s:@SYSROOT@:$(SYSROOT): $@

CMAKE_FLAGS += -GNinja
CMAKE_FLAGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_FLAGS += -DCMAKE_PREFIX_PATH=$(SYSROOT)/$(PREFIX)
CMAKE_FLAGS += -DPKGROOT=$(PKGROOT)
CMAKE_FLAGS += -DCMAKE_INSTALL_LIBDIR=$(LIBDIR)
CMAKE_FLAGS += -DCMAKE_TOOLCHAIN_FILE=$(avalonia_toolchain_file)

$(avalonia_skia): $(avalonia_toolchain_file)
	mkdir -p $(builddir)/avalonia.skia
	cd $(builddir)/avalonia.skia && cmake $(CMAKE_FLAGS) $(BASE)/libavalonia.skia
	cd $(builddir)/avalonia.skia && ninja
	cd $(builddir)/avalonia.skia && DESTDIR=$(PKGROOT) ninja install

$(avalonia_symbols): $(avalonia_skia)
	nm $(PKGROOT)/$(PREFIX)/$(LIBDIR)/libavalonia.skia.so | grep '.*\sT\s.*$$' > $@

$(avalonia_lddtree): $(avalonia_skia)
	lddtree $(PKGROOT)/$(PREFIX)/$(LIBDIR)/libavalonia.skia.so > $@

$(L).clean:
	rm -rf $(builddir)
