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