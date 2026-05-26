#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p ./swagger/versionned &&
cp ./swagger/v1/openapi-editor.yaml ./swagger/versionned/openapi-editor.yaml &&
  ./bin/generate_swagger.sh &&
  (ruby -e 'require "yaml" ; require "date" ; YAML.load_file("./swagger/v1/openapi-editor.yaml", permitted_classes: [Date], aliases: true) == YAML.load_file("./swagger/versionned/openapi-editor.yaml", permitted_classes: [Date], aliases: true) ? exit(0) : exit(1)' || (echo "Swagger file for API Éditeur is different after generation" && exit 1)) &&
  exit 0
