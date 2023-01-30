

variable "availability_zone1" {
  type        = string
  description = "availability zone a in aws"
}

variable "availability_zone2" {
  type        = string
  description = "availability b zone in aws"
}

variable "availability_zone3" {
  type        = string
  description = "availability zone c in aws"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default    = ["us-east-1"] #You Can Change Whatever region you want
}

variable "key_name" {
  description = " SSH keys to connect to ec2 instance"
  type     = string #You Can Change Whatever key name U want
}

variable "instance_type" {
  description = "instance type for ec2"
  type     = string
}

variable "security_group" {
  description = "Name of security group"
  type     = string
}

variable "tag_name" {
  description = "Tag Name of for Ec2 instance"
  type     = string
}
variable "ami_id" {
  description = "AMI for Ubuntu Ec2 instance"
  type     =  string #Write Your own AMI-ID
}

