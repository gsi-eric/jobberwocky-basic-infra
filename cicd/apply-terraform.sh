#!/bin/bash

# fail on any error
set -eu

# go back to the previous directory
cd ../environments/$ENVIRONMENT

# initialize terraform
terraform init -upgrade

# # apply terraform
terraform apply -auto-approve
#terraform plan

# destroy terraform
# terraform destroy -auto-approve
