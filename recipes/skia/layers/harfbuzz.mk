LAYER:=harfbuzz
include $(DEFINE_LAYER)

HARFBUZZ_GIT_REF?=4.2.1

$(call git_clone, harfbuzz, https://github.com/harfbuzz/harfbuzz.git, $(HARFBUZZ_GIT_REF))

$(call meson, harfbuzz)



include $(BUILD_LAYER)

$(L).clean:
	rm -rf $(builddir)

