# openssl-fips

OpenSSL FIPS 140-2 cryptographic module canister for Docker containers

**Work in progress**

## Description

You can use the content of this repo to build a FIPS-compliant OpenSSL
version with containerized (aka reproducible) results. HAProxy is also
provided as an example of a derivative container that can then be built
with this as a FIPS-compliant application.

## Pre-requisites

- `jq`
- `docker`

## Usage

```sh-session
$ # Build FIPS OpenSSL container with FIPS canister
$ ./build.sh

$ # Build FIPS-compliant HAProxy
$ ./build.sh haproxy

$ # Build just the FIPS canister
$ ./build_fips_canister.sh
```

## Current Progress

- [Linux] OpenSSL FIPS Canister container buildable
- [Linux] FIPS OpenSSL container buildable
- [Linux] FIPS HAProxy container buildable with FIPS-enforcement patch

## TODO

- [Linux] Additional FIPS checks on HAProxy functionality
- [Windows] Pretty much everything

## Authors

- [Srdjan Grubor](https://github.com/sgnn7)
