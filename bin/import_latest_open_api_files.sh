#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: $0 /path/to/siade"
  exit 1
fi

path=$1

cp $path/swagger/openapi.yaml openapi_files/api_entreprise.yaml
cp $path/swagger/api-particulier-open-api.yml openapi_files/api_particulier.yaml
