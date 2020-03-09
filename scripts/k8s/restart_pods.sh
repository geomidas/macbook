#!/usr/bin/env bash

# This will restart the specified pods in the specified namespaces

platforms="ch-support-supplier eastbuyerbank eval01 northbuyer notary southsupplier support test westsupplierbank"
pods="corda payment-commitment postgres-proxy"

for pod in $(echo $pods) ; do
	for pla in $(echo $platforms) ; do
		echo "### Stopping $pod on $pla ###"
		kubectl -n "${pla}" scale deployment "${pod}" --replicas=0
		sleep 2
		echo "### Starting $pod on $pla ###"
		kubectl -n "${pla}" scale deployment "${pod}" --replicas=1
	done
done

watch -n2 "kubectl get pods --all-namespaces | grep 'corda\|proxy\|commitment'"