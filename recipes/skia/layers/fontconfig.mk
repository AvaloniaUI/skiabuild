LAYER:=fontconfig
include $(DEFINE_LAYER)

fontconfig_GIT_REF?=main
$(call git_clone, fontconfig, https://gitlab.freedesktop.org/fontconfig/fontconfig.git, $(fontconfig_GIT_REF))

$(call meson_srcdir, fontconfig, $(SRC_fontconfig)/fontconfig) 


DEPENDS += freetype

include $(BUILD_LAYER)

$(L).clean:
	rm -rf $(builddir)


