FROM archlinux:latest

RUN pacman --noconfirm -Syu \
    sudo \
    libgl \
    make \
    which \
    fontconfig \
    cmake \
    ninja \
    pax-utils \
    base-devel
