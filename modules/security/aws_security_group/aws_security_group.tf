# ========================================================== #
# [処理名]
# セキュリティグループ構築
# 
# [概要]
# セキュリティグループ構築
# ・インバウンドルール
#    接続元:MyIP
#    ポート:22(TCP)、80(TCP)
#
# ・アウトバウンドルール
#    接続先:0.0.0.0/0
#    ポート:全プロトコル
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# 変数名: u_public_subnet_ip
# 値: パブリックサブネットIPアドレス
# 
# [output]
# なし
#
# ========================================================== #

# ALB用セキュリティグループ
resource "aws_security_group" "prj_dev_sg_alb" {
  name        = "prj_dev_sg_alb"
  description = "Allow http and https traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_sg_alb"
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

# 80番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_80_for_alb" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [var.u_allowed_cidr_myip]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_alb.id}"
}

# アウトバウンドルール
resource "aws_security_group_rule" "egress_allow_all_for_alb" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_alb.id}"
}

output "sg_alb_id" {
  value = "${aws_security_group.prj_dev_sg_alb.id}"
}

# webサーバ用セキュリティグループ
resource "aws_security_group" "prj_dev_sg_web" {
  name        = "prj_dev_sg_web"
  description = "Allow http and https traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_sg_web"
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

# 22番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_22_for_web" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.u_allowed_cidr_myip]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

# 80番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_80_for_web" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id  = "${aws_security_group.prj_dev_sg_alb.id}"
  # cidr_blocks = [var.u_allowed_cidr_myip]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

# アウトバウンドルール
resource "aws_security_group_rule" "egress_allow_all_for_web" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

output "sg_web_id" {
  value = "${aws_security_group.prj_dev_sg_web.id}"
}

# ========================================================== #
#   VPCエンドポイントのセキュリティグループ
# ========================================================== #
resource "aws_security_group" "prj_dev_vpc_endpoint_sg" {
  name        = "prj_dev_vpc_endpoint_sg"
  description = "Allow https traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_vpc_endpoint_sg"
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

# 443番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_443" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_vpc_endpoint_sg.id}"
}

# VPCエンドポイントのセキュリティグループ
output "prj_dev_vpc_endpoint_sg_id" {
  value = "${aws_security_group.prj_dev_vpc_endpoint_sg.id}"
}