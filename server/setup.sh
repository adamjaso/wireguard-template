#!/bin/bash

[[ -z "$WIREGUARD_VERSION" ]] && echo "WIREGUARD_VERSION is required (i.e. git tag or commit hash)" && exit 1
[[ -z "$VPN_SERVER_IP" ]] && echo "VPN_SERVER_IP is required (i.e. 10.0.0.1)" && exit 1
[[ -z "$VPN_CLIENT_IP" ]] && echo "VPN_CLIENT_IP is required (i.e. 10.0.0.2)" && exit 1
[[ -z "$VPN_LISTEN_PORT" ]] && echo "VPN_LISTEN_PORT is required (i.e. 3333)" && exit 1

bash shared/genkeys.sh server
read -p 'Enter the client public key: ' client_pubkey
echo "$client_pubkey" > client.pub
bash server/genconfig.sh
