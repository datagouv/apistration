#!/bin/bash

which brew &> /dev/null && brew ls --versions gpgme &> /dev/null || brew install gpgme
which apt-get &> /dev/null && apt-get install libgpgme11-dev
which pacman &> /dev/null && pacman -S gnupg gpgme
find config/gpg_public_keys_for_data_encryption -type f -name "*.asc" -print0 | xargs -0 gpg2 --import
gpg_key_email=`ruby -e 'require "yaml" ; print YAML.load_file("config/encrypt_data_signer_data.yml")["shared"]["signer_email"]'`
gpg_key_passphrase=`ruby -e 'require "yaml" ; print YAML.load_file("config/encrypt_data_signer_data.yml")["shared"]["signer_passphrase"]'`

gpg2 --list-keys | grep "$gpg_key_email" &> /dev/null

if [ $? -ne 0 ] ; then
  echo "Key not found for $gpg_key_email, generate one"

  echo "Key-Type: DSA
  Key-Length: 1024
  Subkey-Type: ELG-E
  Subkey-Length: 1024
  Name-Real: Test User
  Name-Email: $gpg_key_email
  Expire-Date: 0
  Passphrase: $gpg_key_passphrase
  %commit" | gpg2 --batch --gen-key
  mkdir -p ~/.gnupg
  touch ~/.gnupg/gpg.conf
  grep "use-agent" ~/.gnupg/gpg.conf &> /dev/null || echo "use-agent" >> ~/.gnupg/gpg.conf
  grep "pinentry-mode loopback" ~/.gnupg/gpg.conf &> /dev/null || echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
  touch ~/.gnupg/gpg-agent.conf
  grep "allow-loopback-pinentry" ~/.gnupg/gpg-agent.conf &> /dev/null || echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
  echo RELOADAGENT | gpg-connect-agent
fi

psql -f ./db/postgresql_setup.txt
bundle install
bin/rails db:schema:load RAILS_ENV=test
