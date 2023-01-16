#!/bin/bash

SWAGGER_DRY_RUN=0 RAILS_ENV=test bundle exec rails rswag PATTERN="spec/requests/api_entreprise/v3_and_more/**/*_spec.rb"
bundle exec ruby bin/augment_openapi_file.rb
SWAGGER_DRY_RUN=0 RAILS_ENV=test bundle exec rails rswag PATTERN="spec/requests/api_particulier/v3_and_more/**/*_spec.rb"
bundle exec ruby bin/augment_openapi_file.rb
