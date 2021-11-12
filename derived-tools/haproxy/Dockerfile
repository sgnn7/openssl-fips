FROM docker.io/ubuntu:20.04 as build-container

# v2.4.7 is supported until 2026 q2
ENV HAPROXY_VERSION="2.4.8"
# From https://www.haproxy.org/download/2.4/src/haproxy-2.4.8.tar.gz.sha256
ENV HAPROXY_SHA265="e3e4c1ad293bc25e8d8790cc5e45133213dda008bfd0228bf3077259b32ebaa5"

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
                    patch \
                    wget

COPY --from=fips-openssl /opt/fips/ssl "${FIPS_OPENSSL_DIR}"

RUN wget --quiet "${HAPROXY_URL}" && \
    bash -ec "set -euo pipefail; \
        echo '${HAPROXY_SHA265}  ${HAPROXY_FILENAME}' > '${HAPROXY_FILENAME}.sha256' && \
        if ! sha256sum -c '${HAPROXY_FILENAME}.sha256'; then echo 'Checksum mismatch!'; exit 1; fi;" && \
    tar -xzf "${HAPROXY_FILENAME}"

WORKDIR "/opt/haproxy/haproxy-${HAPROXY_VERSION}"

# Apply enforcement patch
COPY 0001-Enforce-FIPS-compliance-at-startup.patch .
RUN patch -p1 -i ./0001-Enforce-FIPS-compliance-at-startup.patch

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
         CFLAGS="-O2 -g -w -fwrapv" \
         LDFLAGS="-Wl,-rpath=${FIPS_OPENSSL_DIR}/lib" \
         -j8 && \
    make install

# Runner container
FROM docker.io/ubuntu:20.04

RUN apt update -q && \
    apt dist-upgrade -yq

COPY --from=fips-openssl /dist /fips-openssl
ENV LD_LIBRARY_PATH=/fips-openssl

ENTRYPOINT /usr/local/sbin/haproxy
COPY --from=build-container /usr/local/sbin/haproxy /usr/local/sbin/haproxy
