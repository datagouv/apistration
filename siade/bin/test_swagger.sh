#!/bin/bash

cp swagger/openapi.yaml swagger/openapi-versionned.yaml &&
  ./bin/generate_swagger.sh &&
  (diff swagger/openapi.yaml swagger/openapi-versionned.yaml || (echo "Swagger file is different after generation" && exit 1)) &&
  exit 0
