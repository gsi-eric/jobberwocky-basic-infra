#!/bin/bash

# fail on any error
set -eu

sudo apt update -y
sudo apt install  software-properties-common gnupg2 curl -y

curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt update -y

sudo apt install terraform -y

terraform --version
