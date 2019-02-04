# WireGuard Demo

This project sets up a WireGuard VPN server and client. The server is
configured for Ubuntu 18.10. The client is configured for Mac OSX.

## Implementation

This project aims to set up a single client and single server WireGuard VPN
network routing all client traffic through the VPN server, including DNS.

### Server

- The server is set up to talk to one client IP address.
- The `AllowedIPs` field is configured to talk to the single client IP address.

### Client

- The client is set up to talk to one server IP address.
- The `DNS` field is configured to point to the server IP address.
- The `AllowedIPs` field is configured to talk to everywhere `0.0.0.0/0`.

## Install Client

The `client/setup.sh` script

1. generates client keys
2. generates client configuration

To set up the VPN client, run this script

```
bash client/setup.sh
```

## Install Server

The `server/install.sh` script

1. builds and loads the WireGuard kernel module from the source
2. installs `dnsmasq` as a local DNS server to proxy DNS over the VPN
3. configures `iptables` firewall rules to allow DNS and wireguard traffic
4. enables IP forwarding

The `server/setup.sh` script

1. generates server keys
2. generates server configuration

To set up the VPN server, run these scripts.

This script will push the local files in this project to the server using
`rsync`.

```
# run on the client
make sync-to-server VPN_SSH_ENDPOINT=<SERVERPUBLICIP>
```

This script will install WireGuard and configure the server

```
# run on the server
bash server/install.sh
bash server/setup.sh
```

## Connecting to the VPN server

Once you have installed and set up configurations on both the client and server,
you are ready to start the server and client.

First, start the WireGuard server

```
# run on the server
wg-quick up ./wg0.conf
```

Next, start the WireGuard client

```
# run on the client
wg-quick up ./client.conf
```

If all is set up correctly, the VPN should work.

## Troubleshooting

### DNS

Check that DNS is configured correctly on the client.

```
# run on the client
# the IP address below is an example of the VPN server IP
dig google.com @10.0.0.1
```

### Endpoint

Check that `Endpoint` IP is correct.

# My WireGuard FAQs

* How do I parse multiple peers with Python, since Python's config parser does not support duplicate sections (i.e. Peer, Peer, etc)?

    * https://lists.zx2c4.com/pipermail/wireguard/2017-November/001980.html

* What does AllowedIPs mean? Which IPs are allowed?

    * https://lists.zx2c4.com/pipermail/wireguard/2016-August/000355.html
