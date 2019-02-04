#!/bin/bash

BUILDDIR=/tmp/WireGuard
[[ -z "$WIREGUARD_VERSION" ]] && echo "WIREGUARD_VERSION is required (i.e. git tag or commit hash)" && exit 1

set -ex

apt-get update
apt-get install -q -y git gcc make libelf-dev libmnl-dev
[[ ! -d "$BUILDDIR" ]] && git clone https://git.zx2c4.com/WireGuard/ $BUILDDIR || :
cd $BUILDDIR/src
git checkout $WIREGUARD_VERSION
make clean module module-install install
modinfo wireguard
