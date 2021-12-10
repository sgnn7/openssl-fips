#!/bin/bash

set -euo pipefail

OPENSSL_FIPS_MODULE_FILENAME="OpenSSL_2.0.13_OracleFIPS_1.0.tar.gz"
OPENSSL_FIPS_MODULE_HMAC_SHA1="ef8f7a91979cad14d033d8803a89fdf925102a30"
OPENSSL_FIPS_MODULE_HMAC_KEY="etaonrishdlcupfm"

echo "Downloading ${OPENSSL_FIPS_MODULE_FILENAME}..."
wget --quiet "https://github.com/oracle/solaris-openssl-fips/releases/download/v1.0/${OPENSSL_FIPS_MODULE_FILENAME}"

echo "Verifying checksum..."
hmac=$(openssl sha1 -r -hmac "${OPENSSL_FIPS_MODULE_HMAC_KEY}" "${OPENSSL_FIPS_MODULE_FILENAME}" | awk '{print $1}')
if [ "${hmac}" != "${OPENSSL_FIPS_MODULE_HMAC_SHA1}" ]; then
  echo "Checksum FIPS module mismatch! Expected ${OPENSSL_FIPS_MODULE_HMAC_SHA1} but got ${hmac}!"
  exit 1
fi
echo "Checksum: OK"

# Exact build steps from security policy:
# https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp4024.pdf
#
# ---------------- DO NOT MODIFY LINES BELOW HERE ----------------
tar -zxf OpenSSL_2.0.13_OracleFIPS_1.0.tar.gz

cd "OracleFIPS_1.0"

./config
make
make install
# ---------------- DO NOT MODIFY LINES ABOVE HERE ----------------


# Copy required files to the root of the drive for consistency
# across platforms

case "$(uname -s)" in
  MSYS*) root_dir="/c";;
  *)     root_dir="/";;
esac

target_dir="${root_dir}/usr/local"
if [ ! -d "${target_dir}/ssl" ]; then
  echo "Copying build artifacts to ${target_dir}..."
  mkdir -p "${target_dir}"
  cp -r "/usr/local/ssl" "${target_dir}"
fi

echo "Cleaning up..."
rm -rf "../OracleFIPS_1.0"
