#!/bin/bash

app="$1"

if [ -z $1 ]
then
    echo 'Also specify an app. Current apps running:'
    kubectl get pods | cut -d '-' -f 1 | tail -n '+2'
    echo
fi

while true
    do
    # Get old pods
    old_pods=$(kubectl get pod | grep "$app" | awk 'match($5,/[6-9]+m+*/) {print $1}')
    # Delete old pods
    for pod in $old_pods
    do
        kubectl delete pod "$pod"
    done
    # Throttle
    sleep 1
done