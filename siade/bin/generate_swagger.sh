#!/bin/bash

SWAGGER_DRY_RUN=0 RAILS_ENV=test bundle exec rails rswag PATTERN="spec/requests/api_*/**/*_spec.rb"
bundle exec ruby bin/augment_openapi_entreprise_file.rb
bundle exec ruby bin/merge_swaggers_particulier.rb
