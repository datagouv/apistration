#!/bin/bash

RAILS_ENV=test bundle exec rails rswag
bundle exec ruby bin/add_samples_to_openapi_file.rb
