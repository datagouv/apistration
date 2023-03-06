#!/bin/bash

mkdir ./swagger/versionned &&
cp ./swagger/openapi-entreprise.yaml ./swagger/versionned/openapi-entreprise.yaml &&
  ./bin/generate_swagger.sh &&
  (ruby -e 'require "yaml" ; YAML.load_file("./swagger/openapi-entreprise.yaml") == YAML.load_file("./swagger/versionned/openapi-entreprise.yaml") ? exit(0) : exit(1)' || (echo "Swagger file is different after generation" && exit 1)) &&
  exit 0
