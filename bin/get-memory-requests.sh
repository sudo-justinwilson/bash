#!/bin/bash

export NODE_NAME=${1}
export KUBE_CONTEXT=${2}

usage() {
    echo "${0} NODE_NAME KUBE_CONTEXT";
    echo "";
    echo "where:";
    echo "   NODE_NAME:      the name of the worker node";
    echo "   KUBE_CONTEXT:   the kube context to use";
}

if [[ ${#} -eq 2 ]]; then
    # get the memory requested by pods on the node:
    #k -n prod get pods --all-namespaces --field-selector  spec.nodeName=ip-10-2-32-120.ap-southeast-2.compute.internal
    #kubectl --context ${KUBE_CONTEXT} -n prod get pods --all-namespaces --field-selector  spec.nodeName=${NODE_NAME} -o json  |  jq '.items[].spec.containers[0].resources.requests.memory' | grep -iv null | tr -d '"' | tr -d 'Mi' | paste -sd+ - | bc;
    # I can't add them together because sometimes it uses "Mi", but other times it uses "Gi"
    kubectl --context ${KUBE_CONTEXT} -n prod get pods --all-namespaces --field-selector  spec.nodeName=${NODE_NAME} -o json  |  jq '.items[].spec.containers[0].resources.requests.memory' | grep -iv null | tr -d '"';
    # paste -sd+ - | bc
    # | tr -d 'Mi' | paste -sd+ - | bc
else
    usage;
fi
