#!/bin/bash

cp swagger/v3/openapi.yaml swagger/v3/openapi-versionned.yaml &&
  ./bin/generate_swagger.sh &&
  (diff swagger/v3/openapi.yaml swagger/v3/openapi-versionned.yaml || (echo "Swagger file is different after generation" && exit 1)) &&
  exit 0
