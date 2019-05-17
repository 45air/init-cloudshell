#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

bold() {
  echo ". $( tput bold )" "$*" "$( tput sgr0 )";
}

err() {
  echo "$*" >&2;
}

bold "Setting up Cloud Shell with 45AIR GCloud settings"

bold "Create SSH directory"
mkdir -p -- "/home/$USER/.ssh"
chmod 700 -- "/home/$USER/.ssh"

bold "Decrypt private key and setup SSH for github"
gcloud decrypt --key=bot-key --keyring=github --location=global --ciphertext-file="$DIR/id_rsa.enc" --plaintext-file="/home/$USER/.ssh/id_rsa"
cp -- "$DIR/id_rsa.pub" "/home/$USER/.ssh/id_rsa.pub"
chmod 600 /home/$USER/.ssh/id_rsa
chmod 644 /home/$USER/.ssh/id_rsa.pub
eval $(ssh-agent)
ssh-add

bold "Create GOPATH directory"
mkdir -p -- "/home/$USER/gopath"

bold "Get Mozilla SOPS"
go get -u go.mozilla.org/sops/cmd/sops