FROM docker.io/ubuntu:20.04

ENV OPENSSL_FIPS_MODULE_VER=2.0.13
ENV OPENSSL_FIPS_MODULE_FILENAME="OpenSSL_${OPENSSL_FIPS_MODULE_VER}_OracleFIPS_1.0.tar.gz"

ENV OPENSSL_FIPS_MODULE_HMAC_SHA1="ef8f7a91979cad14d033d8803a89fdf925102a30"
ENV OPENSSL_FIPS_MODULE_HMAC_KEY="etaonrishdlcupfm"

ARG OPENSSL_VER=1.0.2o

WORKDIR /

RUN apt update && \
    apt install -y gcc \
                   make \
                   wget

RUN wget --quiet "https://github.com/oracle/solaris-openssl-fips/releases/download/v1.0/${OPENSSL_FIPS_MODULE_FILENAME}" && \
    bash -ec "set -euo pipefail; \
        hmac=\$(openssl sha1 -r -hmac '${OPENSSL_FIPS_MODULE_HMAC_KEY}' '${OPENSSL_FIPS_MODULE_FILENAME}' | awk '{print \$1}'); \
        if [ "\${hmac}" != "${OPENSSL_FIPS_MODULE_HMAC_SHA1}" ]; then echo 'Chacksum mismatch!'; exit 1; fi;"

RUN tar -zxf "OpenSSL_${OPENSSL_FIPS_MODULE_VER}_OracleFIPS_1.0.tar.gz"

RUN cd "OracleFIPS_1.0" && \
    ./config && \
    make && \
    make install
