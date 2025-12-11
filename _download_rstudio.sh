#!/bin/bash

RSTUDIO_VERSION="2025.09.2-418"
OS_CODENAME=jammy # https://posit.co/download/rstudio-server gives jammy regardless of ubuntu version
FNAME="rstudio-$RSTUDIO_VERSION.deb"

# detect ARCH if not already set (prefer Debian style), map common uname values
ARCH="${ARCH:-$(dpkg --print-architecture 2>/dev/null || uname -m)}"
case "$ARCH" in
    x86_64) ARCH=amd64 ;;
    aarch64) ARCH=arm64 ;;
    ppc64le) ARCH=ppc64le ;;
esac

echo "Downloading rstudio $RSTUDIO_VERSION in /var/cache/apt/archives/"
curl -sSL "https://s3.amazonaws.com/rstudio-ide-build/server/$OS_CODENAME/$ARCH/rstudio-server-$RSTUDIO_VERSION-$ARCH.deb" -o "/var/cache/apt/archives/$FNAME"


echo "Unpacking /var/cache/apt/archives/$FNAME in /usr/lib/rstudio-server/"
mkdir -p /usr/lib/rstudio-server/
dpkg -x "/var/cache/apt/archives/$FNAME" "/"
rm "/var/cache/apt/archives/$FNAME"
