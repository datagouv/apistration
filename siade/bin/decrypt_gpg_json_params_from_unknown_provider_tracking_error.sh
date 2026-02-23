#!/bin/bash

gpg --list-secret-keys | grep equipe@entreprise.api.gouv.fr &> /dev/null

if [ $? -ne 0 ]; then
  echo -ne "You need to import the GPG secret key first. Check ansible repository for file private.asc (encrypted)\nRun the following command from ansible repo:\n> ansible-vault view roles/siade/files/private.asc | gpg --import\n"
  exit 1
fi

file=$1

if [ -f "$file" ] ; then
  echo -ne "Notes:\n1. File should begins with '-----BEGIN PGP MESSAGE-----'\n2. You need to get the passphrase from the ansible repository\n   > ansible-vault view secrets/siade_gpg_infos.yml\n\n--------------------\n"
  decrypted_string=$(gpg --decrypt $file 2> /dev/null)

  echo $decrypted_string | jq .
else
  echo "Usage: $0 /path/to/encrypted_json_params.gpg"
fi
