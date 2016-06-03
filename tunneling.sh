#!/bin/bash

if [ -f .config ]; then
  source .config
else
  echo File config not existing
  exit
fi

createTunnel() {
  /usr/bin/ssh -f $USER@$PUBLIC_HOST -L $1:$PRIVATE_HOST:$1 -N > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo Tunnel $1 created successfully
  else
    echo An error occurred creating a tunnel $?
  fi
}

ports=($PORTS)
for i in ${ports[@]}; do
  ps x | grep "${i}\:$PRIVATE_HOST\:${i}" > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    createTunnel ${i}
  else
    echo Tunnel ${i} exist
  fi
done