FROM debian:buster


# Install build tools

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update   && apt-get upgrade -yy ; \
    apt-get install -yy  \
        automake            \
        build-essential     \
        git                 \
        pkg-config          \
        autopoint           \
        libncurses-dev      \
	upx                 \
        ca-certificates    \
        openssl            \
    ca-certificates \
        curl; \
rm -rf /var/cache/apk/* /tmp/*
RUN update-ca-certificates --verbose --fresh

RUN apt-get update   &&  \
    apt-get install -yy  \
        musl-tools file

ENV CC_MUSL=/usr/bin/musl-gcc



ENV WORKDIR=/build
# Create prefix
WORKDIR /mlibs
WORKDIR $WORKDIR

#SHELL ["/bin/bash", "-o errexit -c"]
SHELL ["/bin/bash", "-c"]


#RUN set -e; \
#	curl -Lf https://github.com/sabotage-linux/kernel-headers/archive/v4.19.88.tar.gz -o kernel-headers-4.19.88.tar.gz; \
#	tar xzf kernel-headers-4.19.88.tar.gz; \
#	cd kernel-headers-4.19.88; \
#	uname -a; \
#	uname -m; \
#        make ARCH=$(uname -m) prefix=/mlibs install; \
#	cd .. && rm -fr kernel-headers-4.19.88 kernel-headers-4.19.88.tar.gz; \
#	ls -laR /mlibs; \
#	ls -laR /usr/include


RUN LIBS=(\
        https://github.com/lz4/lz4/archive/v1.9.2.tar.gz \
        https://github.com/facebook/zstd/releases/download/v1.4.5/zstd-1.4.5.tar.gz \
        https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz \
        https://www.zlib.net/zlib-1.2.11.tar.xz \
        https://tukaani.org/xz/xz-5.2.5.tar.xz \
    ); \
    set -e; \
    for i in ${LIBS[@]}; do \
        curl -LO $i; \
        tar xvf *; \
        cd */; \
            CC="$CC_MUSL" ./configure --prefix=/mlibs || NO_CONFIGURE_ARG="PREFIX=/mlibs"; \
            CC="$CC_MUSL" make -j$(nproc --all); \
            make install $NO_CONFIGURE_ARG; \
            unset NO_CONFIGURE_ARG; \
        cd $WORKDIR; rm -Rf $WORKDIR/*; \
    done


# OPENSSL
RUN set -e; \
    case $(uname -m) in \
    x86_64)             SSL_ARCH=linux-x86_64 ;; \
    amd64)             SSL_ARCH=linux-amd64 ;; \
    x86)             SSL_ARCH=linux-x86 ;; \
    x32)             SSL_ARCH=linux-x32 ;; \
    386)             SSL_ARCH=linux-386 ;; \
    i386)             SSL_ARCH=linux-i386 ;; \
    aarch64)          SSL_ARCH=linux-aarch64 ;; \
    arm64*)          SSL_ARCH=linux-arm64 ;; \
    armv7*)     SSL_ARCH=linux-armv7 ;; \
    armv6*)     SSL_ARCH=linux-armv6 ;; \
    armv5*)     SSL_ARCH=linux-armv5 ;; \
    ppc64le)     SSL_ARCH=linux-ppc64le ;; \
    s390x)     SSL_ARCH=linux-s390x ;; \
    mips64le)     SSL_ARCH=linux-mips64le ;; \
    riscv64)     SSL_ARCH=linux-riscv64 ;; \
    *)                  echo "ERR: unknown! $(uname -m) is output form uname -m"; exit 1 ;; \
    esac; \
    \
    if [[ $(getconf LONG_BIT) -eq 32DISABELD ]]; then \
        SSL_ARCH=linux-x32; \
    fi; \
    echo $SSL_ARCH; \
    \
    curl -LO https://github.com/openssl/openssl/archive/OpenSSL_1_0_2u.tar.gz; \
        tar xvf *; \
        cd */; \
            CC="$CC_MUSL" ./Configure $SSL_ARCH --prefix=/mlibs; \
            make -j$(nproc --all); \
            make install; \
        cd $WORKDIR; rm -Rf $WORKDIR/*;




# Always will be a empty dir
RUN mkdir /out
ENV LIBS_MUSL=/mlibs/

############################
ENV CFLAGS_MUSL="-I/mlibs/include/ -I/mlibs/usr/local/include/ -I/include/"
ENV LDLAGS_MUSL="-L/mlibs/lib/ -L/mlibs/usr/local/lib/ -L/lib/"
