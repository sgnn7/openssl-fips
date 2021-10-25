FROM docker.io/ubuntu:20.04 as build-container

# v2.4.7 is supported until 2026 q2
ENV HAPROXY_VERSION="2.4.7"
# From https://www.haproxy.org/download/2.4/src/haproxy-2.4.7.tar.gz.sha256
ENV HAPROXY_SHA265="52af97f72f22ffd8a7a995fafc696291d37818feda50a23caef7dc0622421845"

ENV HAPROXY_FILENAME="haproxy-${HAPROXY_VERSION}.tar.gz"
ENV HAPROXY_URL="https://www.haproxy.org/download/2.4/src/${HAPROXY_FILENAME}"
ENV FIPS_OPENSSL_DIR="/opt/fips-openssl/ssl"

WORKDIR /opt/haproxy

RUN apt update -q && \
    apt install -qy coreutils \
                    gcc \
                    libpcre2-dev \
                    libz-dev \
                    make \
                    wget

COPY --from=fips-openssl /opt/fips/ssl "${FIPS_OPENSSL_DIR}"

RUN wget --quiet "${HAPROXY_URL}" && \
    bash -ec "set -euo pipefail; \
        echo '${HAPROXY_SHA265}  ${HAPROXY_FILENAME}' > '${HAPROXY_FILENAME}.sha256' && \
        if ! sha256sum -c '${HAPROXY_FILENAME}.sha256'; then echo 'Checksum mismatch!'; exit 1; fi;" && \
    tar -xzf "${HAPROXY_FILENAME}"

WORKDIR "/opt/haproxy/haproxy-${HAPROXY_VERSION}"

RUN make TARGET=linux-glibc \
         USE_LIBCRYPT= \
         USE_PCRE2=1 \
         USE_STATIC_PCRE2=1 \
         USE_PCRE2_JIT=1 \
         USE_OPENSSL=1 \
         USE_THREAD=1 \
         USE_ZLIB=1 \
         SSL_INC="${FIPS_OPENSSL_DIR}/include" \
         SSL_LIB="${FIPS_OPENSSL_DIR}/lib" \
         CC="${FIPS_OPENSSL_DIR}/fips-2.0/bin/fipsld" \
         FIPSLD_CC=gcc \
         LDFLAGS="-Wl,-rpath=${FIPS_OPENSSL_DIR}/lib" \
         -j1 && \
    make install

# TODO: Sanity check and bail-out patch application
# ENV LD_LIBRARY_PATH=/usr/local/ssl/lib
