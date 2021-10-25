#!/bin/bash

set -euo pipefail

echo "Building FIPS HAProxy..."
sudo docker build -t fips-haproxy .
echo "Building FIPS HAProxy: OK"
