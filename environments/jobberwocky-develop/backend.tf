#-------------------------------
#
# AWS Provider
#
#-------------------------------
provider "aws" {
  region = "${var.aws_region}"
  default_tags {
    tags = {
      Terraform       = true
      Workload        = "jobberwocky-infra"
    }
  }
}

#-------------------------------
#
# Terraform Backend
#
#-------------------------------

terraform {
  backend "s3" {
    bucket                  = "jobberwocky-develop-infra-tf-state"
    dynamodb_table          = "terraform-infra-state-lock-dynamo"
    key                     = "jobberwocky-develop/terraform.tfstate"
    region                  = "us-east-1"
  }
}
