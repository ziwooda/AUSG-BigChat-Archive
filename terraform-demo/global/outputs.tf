output "s3_bucket" {
  value = aws_s3_bucket.tfstate.arn
}

output "dynamodb_lock" {
  value = aws_dynamodb_table.terraform_state_lock.arn
}