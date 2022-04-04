LAYER:=avalonia_skia
include $(DEFINE_LAYER)

avalonia_symbols:=$(PKGROOT)/libavalonia.skia.symbols
avalonia_install:=$(LSTAMP)/avalonia_install

$(call meson_srcdir, avalonia_skia, $(BASE)/libavalonia.skia)


$(L) += $(avalonia_symbols)
$(L) += $(avalonia_install)

DEPENDS += skia

include $(BUILD_LAYER)

$(L): $(BASE)/libavalonia.skia/meson.build

$(avalonia_symbols): $(LSTAMP)/avalonia_skia
	nm $(SYSROOT)/$(PREFIX)/$(LIBDIR)/libavalonia.skia.so | grep '.*\sT\s.*$$' > $@

$(avalonia_install): $(LSTAMP)/avalonia_skia $(avalonia_symbols)
	cd $(builddir)/avalonia_skia && DESTDIR=$(PKGROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
