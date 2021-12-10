#!/bin/bash

set -euxo pipefail

export OPENSSL_VER="1.0.2u"
export OPENSSL_SHA256="ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16"
export OPENSSL_FILENAME="openssl-${OPENSSL_VER}.tar.gz"

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

echo "Downloading ${OPENSSL_FILENAME}..."
wget --quiet -O "${OPENSSL_FILENAME}" "https://www.openssl.org/source/${OPENSSL_FILENAME}"

echo "Verifying checksum..."
echo "${OPENSSL_SHA256}  ${OPENSSL_FILENAME}" > "${OPENSSL_FILENAME}.sha256"
if ! sha256sum -c "${OPENSSL_FILENAME}.sha256"; then
  echo "Checksum mismatch! ${OPENSSL_FILENAME} failed checksum validation!";
  exit 1
fi
echo "Checksum: OK"

echo "Extracting..."
tar -xzf "${OPENSSL_FILENAME}"

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

echo "Running make install..."
make install_sw

echo "Copying artifacts to ${src_dir_prefix}/dist..."
mkdir -p "${src_dir_prefix}/dist"
cp ./*.pc ./*.so ./*.so.1.0.0 "${src_dir_prefix}/dist"

echo "Cleaning up..."
rm -rf "$src_dir_name"

echo "Build complete!"
