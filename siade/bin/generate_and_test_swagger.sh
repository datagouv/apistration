#!/bin/bash

./bin/generate_swagger.sh &&
  bundle exec rspec ./spec/acceptances/open_api_validation_spec.rb
