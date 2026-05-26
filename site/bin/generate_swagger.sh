#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

SWAGGER_DRY_RUN=0 RAILS_ENV=test bundle exec rails rswag \
  PATTERN="spec/integration/**/*_spec.rb"
