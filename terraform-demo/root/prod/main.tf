# 각 모듈에 대하여 terraform.tfstate 저장 경로 동적 처리
# terraform {
#   backend "s3" {
#     bucket = "terraform-remote-state-camezii"
#     key    = "dev/iam/terraform.tfstate"
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

