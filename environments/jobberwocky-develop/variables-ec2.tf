#----------------------------------------------------------------------
#
#  Ec2 Variables
#
#-----------------------------------------------------------------------

variable "instance_type" {
  type = string
  description = "The type of ec2 instance"
  default = "t2.micro"
}

variable "ami" {
  type = string
  description = "The image id for ec2 instance"
}
