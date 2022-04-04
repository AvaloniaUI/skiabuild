LAYER:=avalonia_skia
include $(DEFINE_LAYER)

avalonia_skia:=$(LSTAMP)/avalonia.skia
avalonia_symbols:=$(PKGROOT)/libavalonia.skia.symbols
avalonia_install:=$(LSTAMP)/avalonia_install

#$(call meson_srcdir, avalonia_skia, $(BASE)/libavalonia.skia)

$(L) += $(avalonia_skia)
$(L) += $(avalonia_symbols)
$(L) += $(avalonia_install)

DEPENDS += skia

include $(BUILD_LAYER)

$(L): $(BASE)/libavalonia.skia/meson.build

CMAKE_FLAGS += -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$(SYSROOT)/$(PREFIX) -DPKGROOT=$(PKGROOT) -DCMAKE_INSTALL_LIBDIR=$(LIBDIR)

$(avalonia_skia):
	mkdir -p $(builddir)/avalonia.skia
	cd $(builddir)/avalonia.skia && cmake $(CMAKE_FLAGS) $(BASE)/libavalonia.skia
	cd $(builddir)/avalonia.skia && ninja
	cd $(builddir)/avalonia.skia && DESTDIR=$(PKGROOT) ninja install

$(avalonia_symbols): $(avalonia_skia)
	nm $(PKGROOT)/$(PREFIX)/$(LIBDIR)/libavalonia.skia.so | grep '.*\sT\s.*$$' > $@

$(L).clean:
	rm -rf $(builddir)
