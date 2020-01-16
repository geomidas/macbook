#!/bin/bash

evicted_pods="$(kubectl get pods | grep Evicted | awk '{print $1}')"

if ! [ -z "$evicted_pods" ]
then
    kubectl delete pods "$evicted_pods"
fi