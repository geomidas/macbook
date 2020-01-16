#!/bin/bash


# <--- Variables -------------------------------------------------------------->
podname='chrome'
outfile='./chrome.log'

# <--- Main ------------------------------------------------------------------>
# Wait for pod to get created
while true
do 
    pod="$( kubectl get pods | grep 'Running' | grep ${podname} | awk '{print $1}' )"
    # When a pod is found
    if ! [ -z "${pod}" ]
    then
        # Append the pod log into a log file
        echo "Executing: kubectl logs ${pod} -c browser >> ${outfile}"
        kubectl logs "${pod}" -c browser >> ${outfile}
    fi
    sleep 16
done
