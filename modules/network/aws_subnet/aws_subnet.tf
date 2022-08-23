# ========================================================== #
# [処理名]
# Subnet構築
# 
# [概要]
# Subnet構築
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# 変数名: u_public_subnet_ip
# 値: パブリックサブネットIPアドレス
# 
# [output]
# 変数名: public_subnet_id
# 値: パブリックサブネットIPアドレス
#
# ========================================================== #

resource "aws_subnet" "public_subnet_1a" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_public_subnet_1a_ip
  availability_zone = "ap-northeast-1a"
  tags = {
    Env = "dev"
    Name = "prj_dev_public_subnet_1a"
  }
}

output "public_subnet_1a_id" {
  value = "${aws_subnet.public_subnet_1a.id}"
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_public_subnet_1c_ip
  availability_zone = "ap-northeast-1c"
  tags = {
    Env = "dev"
    Name = "prj_dev_public_subnet_1c"
  }
}

output "public_subnet_1c_id" {
  value = "${aws_subnet.public_subnet_1c.id}"
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_private_subnet_1a_ip
  availability_zone = "ap-northeast-1a"
  tags = {
    Env = "dev"
    Name = "prj_dev_private_subnet_1a"
  }
}

output "private_subnet_1a_id" {
  value = "${aws_subnet.private_subnet_1a.id}"
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_private_subnet_1c_ip
  availability_zone = "ap-northeast-1c"
  tags = {
    Env = "dev"
    Name = "prj_dev_private_subnet_1c"
  }
}

output "private_subnet_1c_id" {
  value = "${aws_subnet.private_subnet_1c.id}"
}