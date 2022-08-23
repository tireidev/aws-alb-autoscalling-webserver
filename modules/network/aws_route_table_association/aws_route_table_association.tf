# ========================================================== #
# [処理名]
# RouteTableとPublic Subnetの紐付け
# 
# [概要]
# RouteTableとPublic Subnetの紐付け
#
# [引数]
# 変数名: u_aws_route_table_id
# 値: ルートテーブルID
# 
# 変数名: u_public_subnet_ip
# 値: パブリックサブネットIPアドレス
# 
# [output]
# なし
#
# ========================================================== #

resource "aws_route_table_association" "public_rt_associate_1a" {
  route_table_id = var.u_aws_public_route_table_id
  subnet_id      = var.u_public_subnet_1a_id
}

resource "aws_route_table_association" "public_rt_associate_1c" {
  route_table_id = var.u_aws_public_route_table_id
  subnet_id      = var.u_public_subnet_1c_id
}

resource "aws_route_table_association" "private_rt_associate_1a" {
  route_table_id = var.u_aws_private_route_table_id
  subnet_id      = var.u_private_subnet_1a_id
}

resource "aws_route_table_association" "private_rt_associate_1c" {
  route_table_id = var.u_aws_private_route_table_id
  subnet_id      = var.u_private_subnet_1c_id
}