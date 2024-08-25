locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}


module ec2 {

  source = "../../modules/ec2"

  #-------------------------------------
  # Environment Variables
  #-------------------------------------

  environment = var.environment
  aws_account = var.aws_account

  #-------------------------------------
  # Ec2 Variables
  #-------------------------------------

  instance_type = var.instance_type
  ami           = var.ami

}

module ecr-jobberwocky {
  source     = "../../modules/ecr"
  image_name = "avanture/jobberwocky"

}

module jobberwocky-extra-source {
  source     = "../../modules/ecr"
  image_name = "avanture/jobberwocky-extra-source"
}