FROM localhost:5000/buildsystem

ARG SOURCE

RUN curl -LO $SOURCE

RUN set -ex; \
    tar xvf *; \
    cd */; 
   
# Figure out which config options to use.  This was borrowed from:
#   https://github.com/jelaas/bifrost-build/blob/5df15f90231bdf2f9567b71df4422576334ebe05/all/binutils-2.22-1/B-configure

RUN /bin/sh -c "set -vxe \
    CC="$CC_MUSL" CFLAGS="$CFLAGS_MUSL" LDFLAGS="$LDLAGS_MUSL -static -all-static" \
    TMPFILE=`pwd`/configure.output \
    ./configure --help > $TMPFILE \
    CONFIGURE_OPTS="" \
    for opt in disable-nls enable-static-link disable-shared-plugins disable-dynamicplugin disable-tls disable-pie; do \
        grep -qs $opt $TMPFILE && CONFIGURE_OPTS="$CONFIGURE_OPTS --$opt" \
    done \
    for opt in enable-static; do \
        grep -qs $opt $TMPFILE && CONFIGURE_OPTS="$CONFIGURE_OPTS --$opt=yes" \
    done \
    for opt in enable-shared; do \
        grep -qs $opt $TMPFILE && CONFIGURE_OPTS="$CONFIGURE_OPTS --$opt=no" \
    done \
    rm -f $TMPFILE \
 ./configure ${CONFIGURE_OPTS} \
            make -j$(nproc --all) \
        strip src/file \
        cp src/file /out/ \
    rm -Rf $WORKDIR/* " 


