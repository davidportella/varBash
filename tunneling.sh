#!/bin/bash

unsetEnv() {
  echo Unset variables
  unset USER
  unset PUBLIC_HOST
  unset PRIVATE_HOST
  unset PORTS
}

createTunnel() {
  /usr/bin/ssh -f $USER@$PUBLIC_HOST -L $1:$PRIVATE_HOST:$1 -N > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo Tunnel $1 created successfully
  else
    echo An error occurred creating a tunnel $?
  fi
}

echo "Using file config .config environment variable"
if [ -f .config ]; then
  source .config
  if [ $# -gt 0 ]; then
    echo "Using command line arguments ( $# )"
    while [[ "$#" > 1 ]]; do case $1 in
      -u|--user) USER="$2";;
      -b|--private-host) PRIVATE_HOST="$2";;
      *);;
    esac; shift
    done
  fi
else
  echo The configuration file does not exist
  exit
fi

ssh -o "BatchMode yes" $USER@$PUBLIC_HOST > /dev/null 2>&1 exit
if [[ $? -eq 0 ]]; then
  echo Auth with id_rsa in $PUBLIC_HOST
else
  echo id_rsa copying in $PUBLIC_HOST
  if [ -f ~/.ssh/id_rsa.pub ]; then
    ssh-copy-id $USER@$PUBLIC_HOST
  else
    echo Do not exist id_rsa.pub, can create one with next command "ssh-keygen -t rsa"
    unsetEnv
    exit
  fi
fi

ports=($PORTS)
for i in ${ports[@]}; do
  ps x | grep "${i}\:$PRIVATE_HOST\:${i}" > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    createTunnel ${i}
  else
    echo Tunnel ${i} exist
  fi
done

unsetEnv
