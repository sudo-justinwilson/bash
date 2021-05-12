#!/bin/bash

prod="eks-production"
sandbox="us-east-1"

usage() {
    echo "${0} [ -r] [-k KUBE_CONTEXT] NODE_NAME";
    echo "Description: print all the pods on a certain node";
    echo "";
    echo "where:";
    echo "   NODE_NAME:      the name of the worker node";
    echo "   -k:   the kube context to use";
    echo "   -r:   only show pods that have been restarted";
}

while getopts "rk:" flag; do
    case "$flag" in
        r ) RESTARTS='true'
            ;;
        k ) CONTEXT=${OPTARG}
            ;;
        \? ) usage
            exit 1
            ;;
    esac
done

NODE_NAME=${@:$OPTIND:1}

export KUBE_CONTEXT=${CONTEXT:-$prod}

if [[ ! -n ${NODE_NAME} ]]; then
    usage;
    exit 1;
elif [[ -n ${RESTARTS} ]]; then
    kubectl --context ${KUBE_CONTEXT:eks-production} get pods -o wide --all-namespaces --field-selector  spec.nodeName=${NODE_NAME} --no-headers=true | awk '$5 > 0 { print $2 }';
else
    kubectl --context ${KUBE_CONTEXT:eks-production} get pods -o wide --all-namespaces --field-selector  spec.nodeName=${NODE_NAME} --no-headers=true;
fi
