#!/bin/bash

gpg --list-secret-keys | grep equipe@entreprise.api.gouv.fr &> /dev/null

if [ $? -ne 0 ]; then
  echo -n "You need to import the GPG secret key first. Check ansible repository for file private.asc (encrypted)\nRun the following command from ansible repo:\n> ansible-vault view roles/siade/files/private.asc | gpg --import\n"
  exit 1
fi

file=$1

if [ -f "$file" ] ; then
  decrypted_string=$(gpg --decrypt $file 2> /dev/null)

  echo $decrypted_string | python -m json.tool
else
  echo "Usage: $0 /path/to/encrypted_json_params.gpg"
fi
