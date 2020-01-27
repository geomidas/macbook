#!/bin/bash

evicted_pods="$(kubectl get pods | grep Evicted | awk '{print $1}')"

if ! [ -z "$evicted_pods" ]
then
	for pod in ${evicted_pods}
	do
    		kubectl delete pods "$pod"
	done
fi

