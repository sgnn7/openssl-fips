#!/bin/bash -e

set -euo pipefail

# Exact installation steps from security policy:
# https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp4024.pdf

tar -zxf OpenSSL_2.0.13_OracleFIPS_1.0.tar.gz

cd "OracleFIPS_1.0"

./config
make
make install
