FROM archlinux:latest

RUN pacman --noconfirm -Syu \
    sudo \
    libgl \
    make \
    which
