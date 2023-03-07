#!/bin/bash

cp swagger/openapi-entreprise.yaml swagger/openapi-entreprise-versionned.yaml &&
  ./bin/generate_swagger.sh &&
  (ruby -e 'require "yaml" ; YAML.load_file("./swagger/openapi-entreprise.yaml") == YAML.load_file("./swagger/openapi-entreprise-versionned.yaml") ? exit(0) : exit(1)' || (echo "Swagger file is different after generation" && exit 1)) &&
  exit 0
