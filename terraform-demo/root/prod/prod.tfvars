# network
env            = "prod"
tags           = "demo"
vpc_cidr_block = "10.20.0.0/16"
az             = ["ap-northeast-2a", "ap-northeast-2c"]
az_tag         = ["2a", "2c"]

# ec2
instance_type = "t2.micro"
type          = "gp2"
size          = 50
