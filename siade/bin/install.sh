#!/bin/bash

which brew &> /dev/null && brew ls --versions gpgme &> /dev/null || brew install gpgme
which apt-get &> /dev/null && apt-get install libgpgme11-dev
find config/gpg_public_keys_for_data_encryption -type f -name "*.asc" -print0 | xargs -0 gpg2 --import

psql -f ./db/postgresql_setup.txt
bundle install
bin/rails db:schema:load RAILS_ENV=test
