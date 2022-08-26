# ========================================================== #
# Route TableとPublic Subnetの紐付け
# ========================================================== #
resource "aws_route_table_association" "public_rt_associate_1a" {
  route_table_id = var.u_aws_public_route_table_id
  subnet_id      = var.u_public_subnet_1a_id
}

resource "aws_route_table_association" "public_rt_associate_1c" {
  route_table_id = var.u_aws_public_route_table_id
  subnet_id      = var.u_public_subnet_1c_id
}

# ========================================================== #
# Route TableとPrivate Subnetの紐付け
# ========================================================== #
resource "aws_route_table_association" "private_rt_associate_1a" {
  route_table_id = var.u_aws_private_route_table_id
  subnet_id      = var.u_private_subnet_1a_id
}

resource "aws_route_table_association" "private_rt_associate_1c" {
  route_table_id = var.u_aws_private_route_table_id
  subnet_id      = var.u_private_subnet_1c_id
}