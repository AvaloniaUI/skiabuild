FROM archlinux:latest

RUN pacman -Syu --noconfirm \
        base-devel

RUN pacman -Syu --noconfirm \
        ninja \
        meson \
        git
