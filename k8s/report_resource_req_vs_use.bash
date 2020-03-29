#!/usr/bin/env bash
# <--- Info ------------------------------------------------------------------>
#
#	 - Scans Kubernetes cluster for pods with resource requests
#	 - Gets pod resource use
#	 - Stores the table in a CSV file

# <------------- Vars -------------------------------------------------------->
# Where the report will be stored
report_path="$HOME"
# Colors
end="\033[0m"
red="\033[0;31m"
blue="\033[0;34m"
green="\033[0;32m"
yellow="\033[0;33m"
purple="\033[0;35m"
lightblue="\033[0;36m"

# <------------- Functions --------------------------------------------------->
function get_cluster_name() {
	cluster_name=$(kubectl cluster-info | grep 'Kubernetes master' | cut -d '/' -f3 | cut -d '-' -f 1)
}

function init_files() {
	# Set file names
	report_final="${report_path}/pod_requests_vs_use-${cluster_name}.csv"
	pod_requests="${report_path}/pod_requests-${cluster_name}.tmp"
	# (Re)create files
	for file in "${report_final}" "${pod_requests}" ; do
		if [ -e "${file}" ] ; then
			rm -f "${file}"
		fi
		touch "${file}"
	done
	}

function fetch_pod_requests() {
	echo
	echo
	blue ' - Fetching pod resource requests from kubernetes... '
	echo
	echo
	kubectl get pods -o json --all-namespaces |\
		jq -r '.items[] | .metadata.namespace + "," + .metadata.name + "," + .spec.containers[].resources.requests.cpu + "," + .spec.containers[].resources.requests.memory' |\
		grep -v ',,' | grep -v 'kube-system' | sort -t',' -k4 -n -u >> ${pod_requests}
	# debugging info
	cat ${pod_requests}
	}

function generate_report() {
	echo
	echo 
	blue ' - Generating report... '
	echo
	echo
	# Generating title
	echo 'Namespace,Pod,CPU Request,Mem Request,CPU Use,Mem Use' >> "${report_final}"

	# Checking pods that have defined requests, one by one
	while IFS= read -r line
	do
		pod_namespace=$(echo ${line} | cut -d ',' -f1)
		pod_name=$(echo ${line} | cut -d ',' -f2)
		lightblue "Checking pod: ${pod_name} -n ${pod_namespace}"
		# Check if pod is Running
		if ! kubectl get pod "${pod_name}" -n ${pod_namespace} | grep -q 'Running' ; then
			yellow "              The pod is not in a Running state, skipping..."
		else
			# Get cpu and mem use
			pod_cpu_usage=$(kubectl top pod "${pod_name}" -n "${pod_namespace}" | tail -n1 | awk '{print $2}')
			pod_mem_usage=$(kubectl top pod "${pod_name}" -n "${pod_namespace}" | tail -n1 | awk '{print $3}')
			# Append cpu and mem use to the report
			echo "${line},${pod_cpu_usage},${pod_mem_usage}" >> "${report_final}"
		fi
	done < ${pod_requests}
	echo
	echo
	blue " - Report is stored here: ${report_final}"
	echo
}

function print_report() {
	blue " - Printing..."
	echo
	echo
	cat "${report_final}"
	echo
	echo
}

function cleanup() {
	rm -f "${pod_requests}"
	}

function red {
	echo -e "${red}${1}${end}"
	}

function green {
	echo -e "${green}${1}${end}"
	}

function yellow {
	echo -e "${yellow}${1}${end}"
	}

function blue {
  echo -e "${blue}${1}${end}"
	}

function purple {
	echo -e "${purple}${1}${end}"
	}

function lightblue {
	echo -e "${lightblue}${1}${end}"
	}

# <------------- Main ------------------------------------------------------->
init_files
fetch_pod_requests
generate_report
print_report
cleanup