#!/bin/bash

app=chrome
command="ps | grep -v driver | grep -q $app && echo ' OK' || echo ' FAILED'"

while true
do
    pods=$(kubectl get pods | grep Running | grep "$app")
    for pod in $(echo $pods | awk '{print $1}')
    do
        if ! [ -z $pod ]
        then
            echo -n $pods | awk '{print $1 }'
            kubectl exec $pod -c browser -- bash -c "$command"
        fi
    done
    sleep 1
done
