FROM localhost:5000/buildsystem

ARG SOURCE

RUN curl -LO $SOURCE

RUN set -ex; \
    apt update; apt install -y lzip; \
    tar xvf *; \
    cd */; \
            ./configure \
                LDFLAGS="-static"; \
            make -j$(nproc --all); \
	   make check; \
        ls -laR; \
	upx -9 -v lzip; \
        cp -p lzip /out/; \
    rm -Rf $WORKDIR/*
