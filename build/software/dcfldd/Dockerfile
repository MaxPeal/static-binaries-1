FROM localhost:5000/buildsystem

ARG SOURCE

RUN curl -LO $SOURCE

RUN set -ex; \
    apt update; apt install -y lzip; \
    tar xvf *; \
    cd */; \
	export DEST="$WORKDIR/LocalInstall"; \
	export DESTDIR="$DEST"; \
            ./configure --enable-static --bindir=/ --sbindir=/ --libexecdir=/ || (./autogen.sh ; ./configure --enable-static --bindir=/ --sbindir=/ --libexecdir=/); \
                LDFLAGS="-static"; \
            make -j$(nproc --all); \
	   make check; \
	make install DESTDIR2=$DEST; \
        ls -laR $DESTDIR; \
	strip --verbose --preserve-dates --enable-deterministic-archives $(find $DESTDIR -xdev -executable -type f) ; \
        cp -p $(find $DESTDIR -xdev -executable -type f) /out/; \
    rm -Rf $WORKDIR/*

#        upx -9 -v $DESTDIR/; \

