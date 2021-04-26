#!/bin/bash

EKS_NAME=${1}

# get the servername of the identity provider:
SERVERNAME=$(curl -s $(aws eks describe-cluster --name ${EKS_NAME} --output json | jq .cluster.identity.oidc.issuer | tr -d '"')/.well-known/openid-configuration | jq .jwks_uri | cut -f3 -d'/')

# get the issuer root CA cert:
# we have to use the 'tac' command to reverse the output because we want the last certificate in the certificate chain, which is the root CA:
echo "Q" | openssl s_client -servername ${SERVERNAME}-showcerts -connect ${SERVERNAME}:443 | tac | awk '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/' | tac > /tmp/${EKS_NAME}-ca.crt

# now get the actual thumbprint:
openssl x509 -in /tmp/${EKS_NAME}-ca.crt -fingerprint -noout | cut -f2 -d'=' | tr -d ':'
