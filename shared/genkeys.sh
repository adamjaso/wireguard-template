#!/bin/bash

KEYNAME="$1"
[[ -z "$KEYNAME" ]] && echo "USAGE: genkeys.sh KEYNAME" && exit 1

key=$KEYNAME.key
pub=$KEYNAME.pub

set -ex

[[ ! -f $key ]] && wg genkey > $key || :
[[ ! -f $pub ]] && wg pubkey < $key > $pub || :
chmod 600 $key
cat $pub
