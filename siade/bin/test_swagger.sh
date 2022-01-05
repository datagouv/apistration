#!/bin/bash

cp swagger/openapi.yaml swagger/openapi-versionned.yaml &&
  ./bin/generate_swagger.sh &&
  (ruby -e 'require "yaml" ; YAML.load_file("./swagger/openapi.yaml") == YAML.load_file("./swagger/openapi-versionned.yaml") ? exit(0) : exit(1)' || (echo "Swagger file is different after generation" && exit 1)) &&
  exit 0
