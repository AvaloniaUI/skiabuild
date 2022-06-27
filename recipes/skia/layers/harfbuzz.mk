LAYER:=harfbuzz
include $(DEFINE_LAYER)

HARFBUZZ_GIT_REF?=4.2.1



$(call git_clone, harfbuzz, https://github.com/harfbuzz/harfbuzz.git, $(HARFBUZZ_GIT_REF))


HARFBUZZ_OPTIONS:=-Dtests=disabled

ifdef WINDOWS
	HARFBUZZ_OPTIONS += -Db_vscrt=mt -Ddefault_library=static
endif

$(call meson, harfbuzz, $(HARFBUZZ_OPTIONS))

include $(BUILD_LAYER)

$(L).clean:
	rm -rf $(builddir)

