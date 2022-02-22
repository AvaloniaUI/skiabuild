LAYER:=freetype
include $(DEFINE_LAYER)

FREETYPE_GIT_REF?=master

$(call git_clone, freetype, https://gitlab.freedesktop.org/freetype/freetype.git, $(FREETYPE_GIT_REF))

$(call meson, freetype)

include $(BUILD_LAYER)

$(L).clean:
	rm -rf $(builddir)

