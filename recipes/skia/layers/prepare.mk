LAYER:=prepare
include $(DEFINE_LAYER)

prepare_dirs:=$(LSTAMP)/dirs

$(L) += $(prepapre_dirs)

include $(BUILD_LAYER)


$(prepare_dirs):
	mkdir -p $(SYSROOT)/$(PREFIX)/$(LIBDIR)
	mkdir -p $(SYSROOT)/$(PREFIX)/include
	$(stamp)
