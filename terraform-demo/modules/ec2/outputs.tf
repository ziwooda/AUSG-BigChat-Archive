output "bastion_instance_id" {
  value = aws_instance.bastion_host.id
}

output "private_instance_id" {
  value = aws_instance.demo_ec2[*].id
}