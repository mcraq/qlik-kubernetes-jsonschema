#!/bin/bash -xe

ARGOCD_VERSION='v1.8.3'
OPENAPI2JSONSCHEMABIN="docker run -i -v ${PWD}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

SCHEMA=https://raw.githubusercontent.com/argoproj/argo-rollouts/refs/tags/${ARGOCD_VERSION}/pkg/apiclient/rollout/rollout.swagger.json
PREFIX=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/${K8S_VERSION}/_definitions.json

rm -Rf schemas/${K8S_VERSION}

$OPENAPI2JSONSCHEMABIN -o "schemas/${ARGOCD_VERSION}/json" --expanded --kubernetes --stand-alone "${SCHEMA}"
$OPENAPI2JSONSCHEMABIN -o "schemas/${ARGOCD_VERSION}/json" --kubernetes --stand-alone "${SCHEMA}"

mkdir -p ${ARGOCD_VERSION}/yaml
for JSON in $(ls ${ARGOCD_VERSION}/json/*.json); do
    BASENAME=$(basename ${JSON})
    yq -p json -o yaml "${JSON}" > "${ARGOCD_VERSION}/yaml/${BASENAME%.json}.yaml"
done
