#!/bin/env bash

while true
do
    pods=$(kubectl get pods | grep ^chrome)
    for pod in $(echo $pods | awk '{print $1}')
    do
        if ! [ -z $pod ]
        then
            echo $pods
            kubectl exec $pod -c browser ps
        fi
    done ; sleep 2 ; clear ;
done
