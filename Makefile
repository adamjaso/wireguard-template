SHELL := /bin/bash

.PHONY: help
help:
	@cat Makefile | grep -E '^[a-z-]+:' | sed 's/://'

.PHONY: sync-to-server
sync-to-server:
	rsync \
		-av \
		--progress \
		--exclude-from=./.gitignore \
		--exclude=.git \
		--include=.envvars \
		./ $(VPN_SSH_ENDPOINT):/root/control

.PHONY: server-install
server-install:
	source .envvars && bash server/install.sh

.PHONY: server-setup
server-setup:
	source .envvars && bash server/setup.sh

.PHONY: server-configure
server-configure:
	source .envvars && bash server/genconfig.sh

.PHONY: client-setup
client-setup:
	source .envvars && bash client/setup.sh

.PHONY: client-configure
client-configure:
	source .envvars && bash client/genconfig.sh

clean:
	@read -n 1 -p 'Are you sure you want to clean all keys and configurations? (n/Y) ' yn && echo && \
		[[ "$$yn" = "y" ]] && rm *.pub *.key *.conf
