variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "vpc_id" {
  description = "VPC ID to run EKS Cluster in"
}

variable "cluster_name" {
  description = "Logical name for the K8s Cluster and related resources"
  default = "kind"
}

variable "ec2_keyname" {
  description = "EC2 Key Pair name to use for instance"
}
