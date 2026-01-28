#!/bin/bash

SWAGGER_DRY_RUN=0 RAILS_ENV=test bundle exec rails rswag PATTERN="spec/requests/api_*/**/*_spec.rb"
bundle exec rails runner bin/augment_openapi_files.rb
