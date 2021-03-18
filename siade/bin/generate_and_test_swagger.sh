#!/bin/bash

./bin/generate_swagger.sh &&
  bundle exec rspec ./swagger/open_api_validation_spec.rb
