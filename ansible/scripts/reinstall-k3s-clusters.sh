#!/usr/bin/env bash

set -e

ansible-playbook -vvv --user core \
  -i inventory/homelab-facts.yml -i inventory/hosted-k3s-homelab.yml \
  books/reinstall-inventory-hosts.yml \
  books/prepare-inventory-hosts.yml \
  books/create-clusters.yml
