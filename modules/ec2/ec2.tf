
resource "aws_security_group" "sg-web" {
  name   = "Web permission"

  # SSH access for access from Web Console
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "ec2_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.environment}_EC2_InstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name  = "${var.environment}_EC2_InstanceRoleProfile"
  role  = aws_iam_role.ec2_instance_role.id
}
resource "aws_instance" "server" {
  ami                   = var.ami
  instance_type         = var.instance_type
  security_groups       = ["${aws_security_group.sg-web.name}"]
  iam_instance_profile  = aws_iam_instance_profile.ec2_instance_role_profile.name


tags = {
    Name = "JobberWocky App"
  }

}