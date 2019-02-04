#!/bin/bash

set -ex

primary_interface=$(ip addr show scope link | awk 'NR==1{gsub(":$","",$2);print $2}')

apt-get update -y
apt-get install dnsmasq -y || :

systemctl stop systemd-resolved
systemctl disable systemd-resolved

echo 'nameserver 8.8.8.8
nameserver 1.1.1.1' > /etc/resolv.conf

echo "domain-needed
interface=$primary_interface
interface=wg0
listen-address=0.0.0.0" > /etc/dnsmasq.conf

systemctl restart dnsmasq
systemctl enable dnsmasq
