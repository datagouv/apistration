#!/bin/bash

RAILS_ENV=test bundle exec rails rswag PATTERN="spec/requests/api_entreprise/**/*_spec.rb"
bundle exec ruby bin/augment_openapi_file.rb
