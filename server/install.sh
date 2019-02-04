#!/bin/bash

set -ex

bash server/install_dns.sh
bash server/install_wireguard.sh
bash server/configure_network.sh
