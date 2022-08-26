# ========================================================== #
# Public Subnet構築(ap-northeast-1a)
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

# ========================================================== #
# Public Subnet構築(ap-northeast-1c)
# ========================================================== #
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

# ========================================================== #
# Private Subnet構築(ap-northeast-1a)
# ========================================================== #
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

# ========================================================== #
# Private Subnet構築(ap-northeast-1c)
# ========================================================== #
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