#!/bin/bash

mkdir ./swagger/versionned &&
cp ./swagger/openapi-entreprise.yaml ./swagger/versionned/openapi-entreprise.yaml &&
cp ./swagger/openapi-particulierv2.yaml ./swagger/versionned/openapi-particulierv2.yaml &&
cp ./swagger/openapi-particulier.yaml ./swagger/versionned/openapi-particulier.yaml &&
  ./bin/generate_swagger.sh &&
  (ruby -e 'require "yaml" ; require "date" ; YAML.load_file("./swagger/openapi-entreprise.yaml", permitted_classes: [Date], aliases: true) == YAML.load_file("./swagger/versionned/openapi-entreprise.yaml", permitted_classes: [Date], aliases: true) ? exit(0) : exit(1)' || (echo "Swagger file for API Entreprise is different after generation" && exit 1)) &&
  (ruby -e 'require "yaml" ; require "date" ; YAML.load_file("./swagger/openapi-particulier.yaml", permitted_classes: [Date], aliases: true) == YAML.load_file("./swagger/versionned/openapi-particulier.yaml", permitted_classes: [Date], aliases: true) ? exit(0) : exit(1)' || (echo "Swagger file for API Particulier is different after generation" && exit 1)) &&
  (ruby -e 'require "yaml" ; require "date" ; YAML.load_file("./swagger/openapi-particulierv2.yaml", permitted_classes: [Date], aliases: true) == YAML.load_file("./swagger/versionned/openapi-particulierv2.yaml", permitted_classes: [Date], aliases: true) ? exit(0) : exit(1)' || (echo "Swagger file for API Particulier is different after generation" && exit 1)) &&
  exit 0
