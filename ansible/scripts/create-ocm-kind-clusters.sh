#!/usr/bin/env bash

kind create cluster --name ocm-controller 
kind create cluster --name netsvcs
rm -f join-ocm-controller.sh
clusteradm init --wait --context kind-ocm-controller --output-join-command-file=join-ocm-controller.sh
bash -x join-ocm-controller.sh "netsvcs --context kind-netsvcs --force-internal-endpoint-lookup"
clusteradm accept --clusters netsvcs --context kind-ocm-controller --wait
kubectl get managedclusters --all-namespaces --context kind-ocm-controller
