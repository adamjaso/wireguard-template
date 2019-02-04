#!/bin/bash

# This was an exercise thaht demonstrated how to set and unset the network
# routes to WireGuard. Practically, this is already handled in wg-quick with
# the "Table" option.

action="$1"
required_network_service=Wi-Fi
default_gateway=$(route -n get default | awk '/gateway/{print$2}')

[[ -z "$VPN_INTERFACE" ]] && echo "VPN_INTERFACE is required (i.e. utun1)" && exit 1
[[ -z "$VPN_GATEWAY" ]] && echo "VPN_GATEWAY is required (i.e. 10.0.0.1)"  && exit 1
[[ -z "$VPN_PUBLIC_IP" ]] && echo "VPN_PUBLIC_IP is required (i.e. VPS public ip)" && exit 1

if [[ $(networksetup -listallnetworkservices | grep "$required_network_service") -ne 0 ]] ; then
    echo "Wi-Fi network services not found."
    exit 1
fi

if [ "$action" = "down" ]; then
    set -x
    sudo route delete -net 0/1 -interface $VPN_INTERFACE ;
    sudo route delete -net 128/1 -interface $VPN_INTERFACE ;
    sudo route delete -net $VPN_PUBLIC_IP/32 $default_gateway ;
    sudo networksetup -setdnsservers "$required_network_service" empty

elif [ "$action" = "up" ]; then
    set -x
    sudo route add -net 0/1 -interface $VPN_INTERFACE ;
    sudo route add -net 128/1 -interface $VPN_INTERFACE ;
    sudo route add -net $VPN_PUBLIC_IP/32 $default_gateway ;
    sudo networksetup -setdnsservers "$required_network_service" $VPN_GATEWAY
fi
