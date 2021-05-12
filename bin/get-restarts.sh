#!/bin/bash

prod="eks-production"
sandbox="us-east-1"

export NODE_NAME=${1}
export KUBE_CONTEXT=${2:-eks-production}

#export KUBE_CONTEXT=${${CONTEXT}:-eks-production}

usage() {
    echo "${0} NODE_NAME KUBE_CONTEXT";
    echo "Description: print all the pods on a certain node";
    echo "";
    echo "where:";
    echo "   NODE_NAME:      the name of the worker node";
    echo "   KUBE_CONTEXT:   the kube context to use";
}

if [[ ${#} -gt 0 ]]; then
    #kubectl --context ${KUBE_CONTEXT} get pods --all-namespaces --field-selector  spec.nodeName=ip-10-2-34-200.ap-southeast-2.compute.internal
    #kubectl --context ${KUBE_CONTEXT} get pods -o wide --all-namespaces --field-selector  spec.nodeName=${NODE_NAME}
    kubectl --context ${KUBE_CONTEXT} get pods -o wide --all-namespaces --field-selector  spec.nodeName=${NODE_NAME} --no-headers=true | awk '$5 > 0 { print $0 }';
else
    usage;
fi
