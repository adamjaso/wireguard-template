#!/bin/bash

[[ -z "$VPN_PUBLIC_IP" ]] && echo "VPN_PUBLIC_IP is required (i.e. VPS public IP)" && exit 1
[[ -z "$VPN_CLIENT_IP" ]] && echo "VPN_CLIENT_IP is required (i.e. 10.0.0.2)" && exit 1
[[ -z "$VPN_SERVER_IP" ]] && echo "VPN_SERVER_IP is required (i.e. 10.0.0.2)" && exit 1
[[ ! -f ./client.key ]] && echo "./client.key not found" && exit 1
[[ ! -f ./server.pub ]] && echo "./server.pub not found" && exit 1

set -ex

python3 $(dirname $0)/../shared/config.py \
    --config client.conf \
    --private-key client.key \
    --public-key server.pub \
    --address "$VPN_CLIENT_IP/32" \
    --allowed-ips 0.0.0.0/0 \
    --endpoint "$VPN_PUBLIC_IP" \
    --support-wg-quick \
    --dns "$VPN_SERVER_IP"
chmod 600 client.conf
