#!/usr/bin/env python

import os
import sys
import argparse
import configparser
from collections import OrderedDict


def update_value(args, args_key, config, section_name, section_key, changes):
    if not config.has_section(section_name):
        config[section_name] = OrderedDict()
    section = config[section_name]
    new_value = str(getattr(args, args_key, None))
    old_value = str(section.get(section_key))

    if new_value == 'None' and old_value == 'None':
        return

    if new_value != 'None' and old_value == 'None':
        changes.append('{0}.{1} added as "{2}"'.format(section_name, section_key, new_value))
        section[section_key] = str(new_value)

    elif new_value != 'None' and new_value != old_value:
        changes.append('{0}.{1} changed from "{2}" to "{3}"'.format(section_name, section_key, old_value, new_value))
        section[section_key] = str(new_value)


def modify_interface(args, config, changes):
    update_value(args, 'address', config, 'Interface', 'Address', changes)
    update_value(args, 'private_key', config, 'Interface', 'PrivateKey', changes)
    update_value(args, 'listen_port', config, 'Interface', 'ListenPort', changes)
    if args.wg_quick:
        update_value(args, 'wg_quick_dns', config, 'Interface', 'DNS', changes)
        update_value(args, 'wg_quick_pre_up', config, 'Interface', 'PreUp', changes)
        update_value(args, 'wg_quick_post_up', config, 'Interface', 'PostUp', changes)
        update_value(args, 'wg_quick_pre_down', config, 'Interface', 'PreDown', changes)
        update_value(args, 'wg_quick_post_down', config, 'Interface', 'PostDown', changes)


def modify_peer(args, config, changes):
    update_value(args, 'public_key', config, 'Peer', 'PublicKey', changes)
    update_value(args, 'allowed_ips', config, 'Peer', 'AllowedIPs', changes)
    update_value(args, 'endpoint', config, 'Peer', 'Endpoint', changes)


def read_file(filename):
    with open(os.path.abspath(filename)) as f:
        return f.read().strip()


def main():
    args = argparse.ArgumentParser()
    args.add_argument('--config', dest='config', type=os.path.abspath, required=True)
    args.add_argument('--address', dest='address', required=True, help='Example: clients 10.0.0.2/32, servers 10.0.0.1/32.')
    args.add_argument('--listen-port', dest='listen_port', type=int, required=False, default=3333)
    args.add_argument('--private-key', dest='private_key', type=read_file, default='private', required=False, help='Private key filename')
    args.add_argument('--public-key', dest='public_key', type=read_file, default='public', required=False, help='Public key filename')
    args.add_argument('--allowed-ips', dest='allowed_ips', required=False, help='Example: clients 0.0.0.0/0, servers 10.0.0.2/32')
    args.add_argument('--endpoint', dest='endpoint', required=False)
    args.add_argument('--support-wg-quick', dest='wg_quick', action='store_true')
    args.add_argument('--dns', dest='wg_quick_dns', required=False, help='Only supported if --support-wg-quick is set')
    args.add_argument('--pre-up', dest='wg_quick_pre_up', required=False, help='Only supported if --support-wg-quick is set')
    args.add_argument('--post-up', dest='wg_quick_post_up', required=False, help='Only supported if --support-wg-quick is set')
    args.add_argument('--pre-down', dest='wg_quick_pre_down', required=False, help='Only supported if --support-wg-quick is set')
    args.add_argument('--post-down', dest='wg_quick_post_down', required=False, help='Only supported if --support-wg-quick is set')
    args = args.parse_args()

    if args.endpoint:
        args.endpoint = ':'.join([args.endpoint, str(args.listen_port)])

    config = configparser.ConfigParser()
    if os.path.isfile(args.config):
        with open(args.config) as f:
            config.read_file(f)

    changes = ['Updating config "{0}"...'.format(os.path.basename(args.config))]
    modify_interface(args, config, changes)
    modify_peer(args, config, changes)
    if len(changes) == 0:
        print('No change.')
        return

    print(os.linesep.join(changes))
    if input('Is this OK? (y/N) ').strip().lower() != 'y':
        print('Aborting...')
        sys.exit(1)
    else:
        print('Writing config...')
        with open(args.config, 'w') as f:
            config.write(f)
        print('DONE.')


if '__main__' == __name__:
    main()
