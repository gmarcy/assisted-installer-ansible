#!/usr/bin/env bash

set -e

#ansible-playbook -vvv --user core -i inventory/homelab-facts.yml books/prepare-remote-host.yml -e hosts_spec='{"netsvcs":{"group_names":["remote_hosts"]}}'
ansible-playbook -vvv --user core -i inventory/homelab-facts.yml books/add-remote-ssh-access.yml -e hosts_spec='{"netsvcs":{"group_names":["remote_hosts"],"authorized_key_name":"work_laptop"}}'
#ansible-playbook -vvv --user core -i inventory/homelab-facts.yml -i inventory/assisted-single-node.yml books/assisted-start-installer-pod.yml
ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=accept-new  core@netsvcs.lab.gmarcy.com sudo sysctl -w fs.inotify.max_user_watches=2099999999
ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=accept-new  core@netsvcs.lab.gmarcy.com sudo sysctl -w fs.inotify.max_user_instances=2099999999
ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=accept-new  core@netsvcs.lab.gmarcy.com sudo sysctl -w fs.inotify.max_queued_events=2099999999
ansible-playbook -vvv --user core -i inventory/homelab-facts.yml -i inventory/hosted-netsvcs.yml books/create-cluster.yml -e cluster_name=netsvcs-cluster
#ansible-playbook -vvv --user core -i inventory/homelab-facts.yml -i inventory/hosted-netsvcs.yml books/install-cluster-operators.yml -e cluster_name=netsvcs-cluster
