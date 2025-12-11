#!/bin/bash

set -euo pipefail

# detect TARGETARCH if not already set (prefer Debian style), map common uname values
TARGETARCH="${TARGETARCH:-$(dpkg --print-architecture 2>/dev/null || uname -m)}"
case "$TARGETARCH" in
    x86_64) TARGETARCH=amd64 ;;
    aarch64) TARGETARCH=arm64 ;;
    ppc64le) TARGETARCH=ppc64le ;;
esac

test "${TARGETARCH}" = 'amd64' && export ARCH='64'
test "${TARGETARCH}" = 'arm64' && export ARCH='aarch64'
test "${TARGETARCH}" = 'ppc64le' && export ARCH='ppc64le'
curl -L "https://micro.mamba.pm/api/micromamba/linux-${ARCH}/${VERSION}" \
| tar -xj -C "/" "bin/micromamba"
