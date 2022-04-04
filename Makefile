BASE:=$(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
include $(BASE)/ve-root/Makefile

DOCKER_IMAGE:=skiabuild

DOCKER:=skiabuild
CONTAINER?=skiabuild

.PHONY:test
test:
	LD_LIBRARY_PATH=$(SYSROOT)/$(PREFIX)/$(LIBDIR) $(SYSROOT)/$(PREFIX)/bin/avalonia.skia.testprog

