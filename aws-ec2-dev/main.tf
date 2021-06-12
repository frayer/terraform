# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

data "aws_vpc" "main" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "main" {
  vpc_id = "${data.aws_vpc.main.id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_spot_instance_request" "dev_instance" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  key_name = "${var.ec2_keyname}"
  security_groups = ["${aws_security_group.allow_ssh.name}"]

  user_data = "${file("scripts/user_data.sh")}"

  root_block_device {
    volume_size = "16"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = "MyAssumeRole"
    actions = [
      "sts:AssumeRole",
      "s3:*"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "assume_role" {
  provider = aws
  name     = "assume_role"
  policy   = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role" "assume_role" {
  name = "assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "assume_role" {
  provider = aws
  role = "${aws_iam_role.assume_role.name}"
  policy_arn = "${aws_iam_policy.assume_role.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.assume_role.name}"
}
