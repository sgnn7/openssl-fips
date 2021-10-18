#!/bin/bash

set -euo pipefail

sudo docker build . -t fips-canister
