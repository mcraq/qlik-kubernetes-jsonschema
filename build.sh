#!/bin/bash -xe

VERSION='2025-08-22'
OPENAPI2JSONSCHEMABIN="docker run -i -v ${PWD}:/out/schemas ghcr.io/mcraq/openapi2jsonschema:latest"

## To retrieve swagger.json:
## $ kubectl get --raw /openapi/v2 > swagger.json

SCHEMA=swagger.json

rm -Rf schemas/${VERSION}

$OPENAPI2JSONSCHEMABIN -o "schemas/${VERSION}/json" --expanded --kubernetes --stand-alone "/out/schemas/${SCHEMA}"
$OPENAPI2JSONSCHEMABIN -o "schemas/${VERSION}/json" --kubernetes --stand-alone "/out/schemas/${SCHEMA}"

mkdir -p ${VERSION}/yaml
for JSON in $(ls ${VERSION}/json/*.json); do
    BASENAME=$(basename ${JSON})
    yq -p json -o yaml "${JSON}" > "${VERSION}/yaml/${BASENAME%.json}.yaml"
done
