#!/bin/bash

RAILS_ENV=test bundle exec rails rswag
bundle exec ruby bin/augment_openapi_file.rb
