# ========================================================== #
# Public Route table作成
# ========================================================== #
resource "aws_route_table" "prj_dev_public_route_table" {
  vpc_id = var.u_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.u_internet_gateway_id
  }
  tags = {
    Env = "dev"
    Name = "prj_dev_public_route_table"
  }
}

output "prj_dev_public_route_table_id" {
  value = "${aws_route_table.prj_dev_public_route_table.id}"
}

# ========================================================== #
# Private Route table作成
# ========================================================== #
resource "aws_route_table" "prj_dev_private_route_table" {
  vpc_id = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_private_route_table"
  }
}

output "prj_dev_private_route_table_id" {
  value = "${aws_route_table.prj_dev_private_route_table.id}"
}