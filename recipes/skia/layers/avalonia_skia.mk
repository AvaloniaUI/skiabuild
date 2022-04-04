LAYER:=avalonia_skia
include $(DEFINE_LAYER)

$(call meson_srcdir, avalonia_skia, $(BASE)/libavalonia.skia)

DEPENDS += skia

include $(BUILD_LAYER)

$(L): $(BASE)/libavalonia.skia/meson.build


$(L).clean:
	rm -rf $(builddir)
