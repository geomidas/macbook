#!/bin/bash

app=chrome
command="ps | grep $app | grep -v driver"

while true
do
    pods=$(kubectl get pods | grep "$app")
    for pod in $(echo $pods | awk '{print $1}')
    do
        if ! [ -z $pod ]
        then
            echo $pods
            kubectl exec $pod -c browser -- bash -c "$command"
        fi
    done
    sleep 1
    clear
done
