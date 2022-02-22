FROM centos:7 AS buildbase

RUN yum --enablerepo=base clean metadata
RUN yum install -y deltarpm
RUN yum update -y
RUN yum install -y  tar \
                    curl \
                    curl-devel \
                    m4 \
                    autoconf \
                    automake \
                    libtool \
                    pkgconfig \
                    openssl-devel \
                    file \
                    patch \
                    bzip2 \
                    zlib-devel \
                    gettext \
                    python-setuptools \
                    python-devel \
                    epel-release \
                    centos-release-scl \
                    git \
                    gcc \
                    gcc-c++ \
                    python3 \
                    expat-devel \
                    dh-autoreconf \
                    curl-devel \
                    gettext-devel \
                    openssl-devel \
                    perl-devel \
                    zlib-devel \
                    mesa-libGL-devel \
                    gperf \
                    gettext-devel \
                    expat-devel \
                    binutils-devel \
                    python3-devel \
                    flex \
                    bison \
                    texinfo \
                    which


RUN pip3 install cmake ninja meson

FROM buildbase AS toolchains

RUN yum install -y devtoolset-10

RUN git clone -v --depth=1 https://github.com/distcc/distcc.git &&  cd distcc && ./autogen.sh && source /opt/rh/devtoolset-10/enable && ./configure && make -j$(nproc) && make install && rm -rf /distcc

RUN ln -s /usr/bin/gcc /usr/bin/gcc-4.8.5
RUN ln -s /usr/bin/g++ /usr/bin/g++-4.8.5

RUN yum -y install glibc-devel.i686

# #
# # Modern GCC
# #
RUN git clone --depth=1 -b releases/gcc-10.3.0 https://github.com/gcc-mirror/gcc
RUN git clone --depth=1 -b binutils-2_38 https://github.com/bminor/binutils-gdb
RUN mkdir -p binutils-gdb/build

RUN cd binutils-gdb/build && ../configure CC='distcc gcc-4.8.5' CXX='distcc g++-4.8.5' --disable-shared --disable-gdb --disable-sim --disable-nls --enable-multilib --enable-multiarch
ENV DISTCC_HOSTS="10.1.0.16/1 10.1.0.24/32 10.1.0.32/8 10.1.0.40/20 10.1.0.48/16"
RUN cd binutils-gdb/build && make -j$(distcc -j)
RUN cd binutils-gdb/build && make install

RUN mkdir -p gcc/build

RUN cd gcc && ./contrib/download_prerequisites
RUN cd gcc/build && ../configure CC='distcc gcc-4.8.5' CXX='distcc g++-4.8.5' \
      --prefix=/usr \
      --target=x86_64-linux-gnu \
      --enable-languages="c,c++" --enable-multilib  --enable-multiarch --enable-threads='posix' --program-suffix=-10
RUN cd gcc/build && make -j$(distcc -j)
RUN cd gcc/build && make DESTDIR=$(pwd)/out install
RUN cd gcc/build && make install

RUN git clone -v --depth=1 -b llvmorg-13.0.1 https://github.com/llvm/llvm-project.git

WORKDIR /llvm-project
RUN mkdir build
RUN cd build && CC="distcc gcc-10" CXX="distcc g++-10" cmake \
                -DCMAKE_INSTALL_PREFIX=/usr/local \
                -DCMAKE_BUILD_TYPE=Release \
                -DLLVM_ENABLE_PROJECTS=clang \
                -G "Ninja" ../llvm

ENV DISTCC_HOSTS="10.1.0.16/8 10.1.0.24/14 10.1.0.40/20 10.1.0.48/16"
RUN cd build && ninja -j$(distcc -j)
RUN cd build && DESTDIR=$(pwd)/out ninja install
RUN cd build && ninja install
RUN cd build/out/usr/local/bin && ln -s clang++ clang++-13
RUN cd /usr/local/bin && ln -s clang++ clang++-13


WORKDIR /
RUN git clone -v --depth=1 -b v2.35.1 https://github.com/git/git.git
RUN cd git && make configure && ./configure CC='distcc clang-13' CXX='distcc clang++-13'
RUN cd git && make -j$(distcc -j)
RUN cd git && make DESTDIR=out install
RUN cd git && make install

RUN git clone -v https://gn.googlesource.com/gn
RUN cd gn && CC='distcc clang-13' CXX='distcc clang++-13' ./build/gen.py
RUN cd gn/out && ninja -j$(distcc -j)

RUN git clone --depth=1 https://gitlab.freedesktop.org/freetype/freetype.git
WORKDIR /freetype
RUN CC="distcc clang-13" CXX="distcc clang++-13" CFLAGS="-fPIC" meson build --buildtype=release && ninja -C build -j$(distcc -j)
RUN ninja -C build install
RUN DESTDIR=$(pwd)/out ninja -C build install

WORKDIR /
RUN git clone --depth=1 https://github.com/freedesktop/fontconfig.git
WORKDIR /fontconfig
RUN CC="distcc clang-13" CXX="distcc clang++-13" CFLAGS="-fPIC" meson build --buildtype=release -Dtests=disabled && ninja -C build -j$(distcc -j)
RUN ninja -C build install
RUN DESTDIR=$(pwd)/out ninja -C build install

WORKDIR /
RUN git clone -v --depth=1 https://github.com/distcc/distcc.git && cd distcc && ./autogen.sh && source /opt/rh/devtoolset-10/enable && ./configure && make -j$(nproc) && make DESTDIR=$(pwd)/out install

WORKDIR /
RUN cd binutils-gdb/build && make DESTDIR=/binutils-gdb/out install

FROM buildbase

COPY --from=toolchains distcc/out/ /
COPY --from=toolchains git/out/ /
COPY --from=toolchains binutils-gdb/out/ /
COPY --from=toolchains gcc/build/out/ /
COPY --from=toolchains llvm-project/build/out/ /
COPY --from=toolchains gn/out/gn /usr/local/bin/
COPY --from=toolchains freetype/out/ /
COPY --from=toolchains fontconfig/out/ /
COPY --from=toolchains gn/out/gn /usr/bin/gn

RUN yum -y install mesa-libGL-devel.i686 glibc-devel.i686 make

RUN mkdir -p /usr/local/git/share/git-core/templates

