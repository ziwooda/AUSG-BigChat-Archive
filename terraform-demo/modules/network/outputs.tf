output "vpc_id" {
    value = aws_vpc.demo_vpc.id
    description = "id of vpc"
}

output "vpc_cidr" {
    value = aws_vpc.demo_vpc.cidr_block
    description = "cidr block of vpc"
}

output "availability_zones" {
  value = var.azs
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnet[*].cidr_block
}

output "private_subnet_cidr_block" {
  value = aws_subnet.private_subnet[*].cidr_block
}
