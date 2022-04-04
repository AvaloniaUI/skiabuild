FROM debian:latest
RUN apt-get -y update && \
    apt-get -y install \
        sudo \
        libgl1-mesa-glx \
        libfontconfig1 \
        make
