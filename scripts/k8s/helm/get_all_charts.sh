#!/usr/bin/env bash

# Get charts deployed on clusters and their status

# -------------- vars -------------
nodepool='tools'
clusters='cluster1 cluster2 cluster3'
chart_filter='logging\|monitoring\|cost-analyzer'

# -------------- main -------------
echo
for cluster in ${clusters} ; do
	echo "${cluster}"
	# Switch cluster
	if ! /usr/local/bin/kubectx "${cluster}-admin" > /dev/null 2>&1 ; then
		echo "  You need to get the credentials for the ${cluster} cluster"
	else
		# Check if the nodepool exists
		if ! kubectl get nodes | grep -q "${nodepool}" ; then
			echo "  The cluster does not have the ${nodepool} node pool"
		else
			# List the charts
			kubectx "${cluster}-admin" > /dev/null 2>&1
			helm2 ls -a | tail -n +2 | grep "${chart_filter}" | awk '{print " ","helm 2","\t",tolower($8),"\t",$1}'
			helm3 ls -a --all-namespaces | tail -n +2 | grep "${chart_filter}" | awk '{print " ","helm 3","\t",$8,"\t",$1}'
		fi
	fi
	echo
done