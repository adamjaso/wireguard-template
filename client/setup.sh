#!/bin/bash

[[ -z "$VPN_PUBLIC_IP" ]] && echo "VPN_PUBLIC_IP is required (i.e. VPS public IP)" && exit 1
[[ -z "$VPN_CLIENT_IP" ]] && echo "VPN_CLIENT_IP is required (i.e. 10.0.0.2)" && exit 1
[[ -z "$VPN_SERVER_IP" ]] && echo "VPN_SERVER_IP is required (i.e. 10.0.0.2)" && exit 1

bash shared/genkeys.sh client
read -p 'Enter the server public key: ' server_pubkey
echo "$server_pubkey" > server.pub
bash client/genconfig.sh
