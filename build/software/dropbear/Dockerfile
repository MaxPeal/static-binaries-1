FROM localhost:5000/buildsystem

ARG SOURCE

RUN curl -LO $SOURCE

RUN set -ex; \
    apt update; apt install -y upx lzip zlib1g-dev libtomcrypt-dev libtommath-dev; \
    tar xvf *; \
    cd */; \
            export MULTI=1; ./configure --enable-static \
                LDFLAGS="-static"; \
            make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" -j$(nproc --all); \
        ls -altr ; strip dropbearmulti; \
        cp dropbearmulti *.1 *.8 /out/; \
    rm -Rf $WORKDIR/*
