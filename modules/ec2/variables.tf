#----------------------------------------------------------------------
#
#  Environment Definition
#
#-----------------------------------------------------------------------

variable "environment" {
    type = string
    description = "Environment for the CodeBuild Project"
}

variable "aws_region" {
  type = string
  description = "Region for your resources to be deployed"
  default = "us-east-1"
}

variable "aws_account" {
  type = string
  description = "AWS Account for your resources to be deployed"
}

#----------------------------------------------------------------------
#
#  Ec2 Variables
#
#-----------------------------------------------------------------------

variable "instance_type" {
  type = string
  description = "The type of instance"
  default = "t2.micro"
}

variable "ami" {
  type = string
  description = "The image id for ec2 instance"
}
