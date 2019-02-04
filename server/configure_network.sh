#!/bin/bash

set -ex

[[ -z "$VPN_LISTEN_PORT" ]] && echo "VPN_LISTEN_PORT is required (i.e. 3333)" && exit 1

primary_interface=$(ip addr show scope link | awk 'NR==1{gsub(":$","",$2);print $2}')
vpn_public_ip=$(ifconfig $primary_interface| awk '/inet /{gsub("addr:","",$2);print$2}')

echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1
sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

iptables -t filter -F
iptables -t nat -F
iptables -t raw -F

iptables -t filter -P OUTPUT ACCEPT
iptables -t filter -P FORWARD ACCEPT
iptables -t filter -P INPUT DROP

# nat
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE

# filter
iptables -t filter -A INPUT -p icmp -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p udp --sport $VPN_LISTEN_PORT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p udp -d $vpn_public_ip --dport 53 -j DROP
iptables -t filter -A INPUT -p udp --sport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --sport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -p tcp --sport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT


iptables -t filter -A INPUT -i wg0 -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
