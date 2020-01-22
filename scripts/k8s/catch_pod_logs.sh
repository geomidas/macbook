#!/bin/bash

# <--- Variables -------------------------------------------------------------->
podname='chrome'

# <--- Main ------------------------------------------------------------------>
# Wait for pod to get created
while true
do 
    pod="$( kubectl get pods | grep 'Running' | grep ${podname} | awk '{print $1}' )"
    # When a pod is found
    if ! [ -z "${pod}" ]
    then
        # Append the pod log into a log file
        echo "Executing: kubectl logs ${pod} -c browser > ${pod}.log"
        kubectl logs "${pod}" -c browser > "${pod}.log"
	export pod_log=$pod
    fi
    sleep 6
done
