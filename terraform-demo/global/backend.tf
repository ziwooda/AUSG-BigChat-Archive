terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# S3 backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-remote-state-camezii"

  # 실수로 S3 버킷 삭제되는 것 방지
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "TerraformStateLock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  deletion_protection_enabled = true

  attribute {
    name = "LockID"
    type = "S"
  }
}
