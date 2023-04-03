#######################################
# console에 생성되어 있는 key pair 불러오기
data "aws_key_pair" "demo_public" {
  key_name = "demo-public-key"
}

data "aws_key_pair" "demo_private" {
  key_name = "demo-private-key"
}

#######################################
# 최신 ami값 불러오기
data "aws_ami" "tf-ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#######################################
# bastion host on public subnet
resource "aws_instance" "bastion-host" {
  ami           = data.aws_ami.tf-ami.id
  instance_type = var.instance_type
  associate_public_ip_address = true

#   vpc_security_group_ids = [
#     var.bastion_sg
#   ]

  availability_zone = "${element(var.azs, 0)}"
  subnet_id = var.public_subnet[0]
  key_name  = data.aws_key_pair.demo_public.key_name

  root_block_device {
    volume_size = var.ebs_size
    volume_type = var.ebs_type

    tags = {
      "Name" = "${var.env}-${var.tag}-bastion-volume"
    }
  }

  tags = {
    "Name" = "${var.env}-${var.tag}-bastion-host"
  }
}

#######################################
# instances on private subnets
resource "aws_instance" "demo-ec2" {
  count         = "${length(var.azs)}"
  ami           = data.aws_ami.tf-ami.id
  instance_type = var.instance_type
#   vpc_security_group_ids = [var.web_sg]

  availability_zone = "${element(var.azs, count.index)}"
  subnet_id = "${element(var.private_subnet, count.index)}"
  key_name  = de

  root_block_device {
    volume_size = var.ebs_size
    volume_type = var.ebs_type

    tags = {
      "Name" = "${var.env}-${var.tag}-private-volume-${count.index+1}"
    }
  }

  tags = {
    "Name" = "${var.env}-${var.tag}-private-instance-${element(var.az_tags, count.index)}"
  }
}
