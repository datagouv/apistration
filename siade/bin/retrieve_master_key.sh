#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: $0 /path/to/ansible/scripts"
  exit 1
fi

path=$1

cd $path

key=`ansible-vault view secrets/siade_master_key.yml | grep MASTER_KEY | awk '{print $2}'`

cd -

echo $key > config/master.key
