#!/bin/bash

if [ -f .config ]; then
  source .config
else
  echo The configuration file does not exist
  exit
fi

if [ -f ~/.ssh/id_rsa.pub ]; then
  cat ~/.ssh/id_rsa.pub | ssh $USER@$PUBLIC_HOST "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
else
  echo Do not exist id_rsa.pub, can create one with next command "ssh-keygen -t rsa"
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
