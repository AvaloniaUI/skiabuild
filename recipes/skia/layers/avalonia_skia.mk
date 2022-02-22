LAYER:=avalonia_skia
include $(DEFINE_LAYER)

$(call meson_srcdir, avalonia_skia, $(BASE)/test)

DEPENDS += skia

include $(BUILD_LAYER)

$(L): $(BASE)/test/meson.build


$(L).clean:
	rm -rf $(builddir)
