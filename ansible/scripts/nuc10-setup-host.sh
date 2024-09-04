#!/usr/bin/env bash

set -e

HOSTNAME=nuc10

ansible-playbook -vvv --user core \
  -i inventory/homelab-facts.yml -i inventory/hosted-${HOSTNAME}.yml \
  -e cluster_name=${HOSTNAME}-cluster \
  books/prepare-inventory-hosts.yml \
  books/create-cluster.yml \
  books/argocd-setup-services.yml
