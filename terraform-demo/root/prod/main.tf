# 각 모듈에 대하여 terraform.tfstate 저장 경로 동적 처리
# terraform {
#   backend "s3" {
#     bucket         = "terraform-remote-state-camezii"
#     key            = "prod/terraform.tfstate"
#     region         = "ap-northeast-2"
#     dynamodb_table = "TerraformStateLock"
#     encrypt        = true
#   }
# }

module "network" {
  source   = "../../modules/network"
  env      = var.env
  tag      = var.tags
  vpc_cidr = var.vpc_cidr_block
  azs      = var.az
}

module "ec2" {
  source        = "../../modules/ec2"
  env           = var.env
  tag           = var.tags
  az_tags       = var.az_tag
  instance_type = var.instance_type
  ebs_size      = var.size
  ebs_type      = var.type

  azs            = module.network.availability_zones
  public_subnet  = module.network.public_subnet_id
  private_subnet = module.network.private_subnet_id
}