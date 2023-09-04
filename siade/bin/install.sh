#!/bin/bash

psql -f ./db/postgresql_setup.txt
bundle install
bin/rails db:schema:load RAILS_ENV=test
