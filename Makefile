BASE:=$(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
include $(BASE)/ve-root/Makefile

DOCKER_IMAGE:=skiabuild

DOCKER:=skiabuild
CONTAINER?=skiabuild


# all:
# 	cd skia && python ./tools/git-sync-deps
# 	cd skia && ./bin/gn gen out/Shared --args='is_official_build=true skia_use_system_harfbuzz=false is_component_build=true'
# 	cd skia/out/Shared && ninja -j16


# docker.build:
# 	cd docker/$(DOCKER) && BASE=$(shell pwd) docker-compose build $(CONTAINER)

# docker.pull:
# 	cd docker/$(DOCKER) && BASE=$(shell pwd) docker-compose pull $(CONTAINER)

# .PHONY: docker
# docker:
# 	cd docker/$(DOCKER) && BASE=$(shell pwd) CURRENT_DIR=$(shell pwd) CURRENT_UID=$(shell id -u) \
# 		CURRENT_GID=$(shell id -g) CURRENT_USER=$(shell whoami) docker-compose run --rm $(CONTAINER) /bin/bash


