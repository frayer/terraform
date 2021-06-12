variable "aws_region" {
  description = "AWS region to launch EC2 instance"
}

variable "vpc_id" {
  description = "VPC ID to run the EC2 instance in"
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "c5a.2xlarge"
}

variable "ec2_keyname" {
  description = "EC2 Key Pair name to use for instance"
}

variable "local_ssh_key" {
  description = "Local SSH key to copy to the remote EC2 instance"
}