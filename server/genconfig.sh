#!/bin/bash

[[ -z "$VPN_SERVER_IP" ]] && echo "VPN_SERVER_IP is required (i.e. 10.0.0.1)" && exit 1
[[ -z "$VPN_CLIENT_IP" ]] && echo "VPN_CLIENT_IP is required (i.e. 10.0.0.2)" && exit 1
[[ ! -f ./server.key ]] && echo "./server.key not found" && exit 1
[[ ! -f ./client.pub ]] && echo "./client.pub not found" && exit 1

set -ex

python3 $(dirname $0)/../shared/config.py \
    --config wg0.conf \
    --private-key server.key \
    --public-key client.pub \
    --address $VPN_SERVER_IP/32 \
    --allowed-ips $VPN_CLIENT_IP/32
chmod 600 wg0.conf
