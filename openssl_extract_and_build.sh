#!/bin/bash

set -euxo pipefail

SSL_ARTIFACTS_DIR="/opt/fips/ssl"

case "$(uname -s)" in
  MSYS*) src_dir_prefix="/c/tmp"
         ssl_dir_prefix="/c"
         ;;
  *)     src_dir_prefix="/"
         ssl_dir_prefix="/"
         ;;
esac
cd "${src_dir_prefix}"

echo "Extracting..."
tar -xzf "openssl.tar.gz"

src_dir_name=$(ls "${src_dir_prefix}" | grep 'openssl-*' | head -1)
cd "${src_dir_name}"

echo "Configuring..."
./config --prefix="${ssl_dir_prefix}/${SSL_ARTIFACTS_DIR}" \
         --openssldir="${ssl_dir_prefix}/${SSL_ARTIFACTS_DIR}" \
         --with-fipsdir="${ssl_dir_prefix}/${SSL_ARTIFACTS_DIR}/fips-2.0" \
         -no-asm -no-ssl2 -no-ssl3 -no-comp \
         -ldl \
         fips shared zlib

echo "Building dependencies..."
make depend

echo "Building OpenSSL..."
make -j8

echo "Running make isntall..."
make install_sw

echo "Build complete!"
