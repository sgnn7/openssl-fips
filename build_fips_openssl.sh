#!/bin/bash

set -euo pipefail

echo "Building the OpenSSL..."
sudo docker build -t fips-openssl -f Dockerfile.openssl .
echo "Building the OpenSSL: OK"
