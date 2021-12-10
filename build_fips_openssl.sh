#!/bin/bash

set -euo pipefail

FOLDER="openssl"

pushd "${FOLDER}" >/dev/null
  ./build.sh
popd >/dev/null
