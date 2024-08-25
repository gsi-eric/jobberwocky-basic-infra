#----------------------------------------------------------------------
#
#  Environment Definition
#
#-----------------------------------------------------------------------

variable "environment" {
  type = string
  description = "The name of the environment where you're gonna deploy your resources"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account" {
  type = string
  description = "Account number where your resources are going to be deployed"
}
