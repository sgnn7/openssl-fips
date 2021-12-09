#!/bin/bash

set -euo pipefail

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
rm -rf "OracleFIPS_1.0"
