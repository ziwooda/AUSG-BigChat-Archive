variable "env" {
  type        = string
  description = "devlopment env"
}

variable "tags" {
  type        = string
  description = "repeated tag of env"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block of vpc"
}

variable "az" {
  type        = list(string)
  description = "availability zone to deploy instances"
}

variable "az_tag" {
  type        = list(string)
  description = "availability zone to deploy instances"
}

variable "instance_type" {
  type        = string
  description = "intance type of ec2 instances"
}

variable "type" {
  type        = string
  description = "type of ebs volume"
}

variable "size" {
  type        = string
  description = "size of ebs volume"
}

