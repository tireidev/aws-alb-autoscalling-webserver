# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# AWS上にALB + AutoScaling構成のNginxを構築する
# 
# [手順]
# 0. プロバイダ設定(AWS)
# 1. ネットワーク構築
#   1.1. VPC構築
#   1.2. IGW構築
#   1.3. RouteTable構築
#   1.4. Subnet構築
#   1.5. RouteTableとPublic Subnetの紐付け
# 2. セキュリティ設定
#   2.1. IAM作成
#   2.2. MyIP取得
#   2.3. VPCエンドポイント構築
#   2.4. セキュリティグループ構築
#   2.5. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
# 3. EC2インスタンス構築
# ========================================================== #

# ========================================================== #
# 0. プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_aws_region
}

# ========================================================== #
# 1. ネットワーク構築
# ========================================================== #
#   1.1. VPC構築
# ========================================================== #
module "aws_vpc" {
  source       = "./modules/network/aws_vpc"
  u_vpc_ip_ip4 = var.u_aws_vpc_cidr
}

# ========================================================== #
#   1.2. IGW構築
# ========================================================== #
module "aws_internet_gateway" {
  source   = "./modules/network/aws_internet_gateway"
  u_vpc_id = module.aws_vpc.id
}

# ========================================================== #
#   1.3. RouteTable構築
# ========================================================== #
module "aws_route_table" {
  source                = "./modules/network/aws_route_table"
  u_vpc_id              = module.aws_vpc.id
  u_internet_gateway_id = module.aws_internet_gateway.id
}

# ========================================================== #
#   1.4. Subnet構築
# ========================================================== #
module "aws_subnet" {
  source                 = "./modules/network/aws_subnet"
  u_vpc_id               = module.aws_vpc.id
  u_public_subnet_1a_ip  = var.u_public_subnet_1a_ip
  u_public_subnet_1c_ip  = var.u_public_subnet_1c_ip
  u_private_subnet_1a_ip = var.u_private_subnet_1a_ip
  u_private_subnet_1c_ip = var.u_private_subnet_1c_ip
}

# ========================================================== #
#   1.5. RouteTableとPublic Subnetの紐付け
# ========================================================== #
module "aws_route_table_association" {
  source                       = "./modules/network/aws_route_table_association"
  u_aws_public_route_table_id  = module.aws_route_table.prj_dev_public_route_table_id
  u_aws_private_route_table_id = module.aws_route_table.prj_dev_private_route_table_id
  u_public_subnet_1a_id        = module.aws_subnet.public_subnet_1a_id
  u_public_subnet_1c_id        = module.aws_subnet.public_subnet_1c_id
  u_private_subnet_1a_id       = module.aws_subnet.private_subnet_1a_id
  u_private_subnet_1c_id       = module.aws_subnet.private_subnet_1c_id
}

# ========================================================== #
# 2. セキュリティ設定
# ========================================================== #
#   2.1. IAM作成
# ========================================================== #
module "aws_iam" {
  source = "./modules/security/aws_iam"
}

# ========================================================== #
#   2.2. MyIP取得
# ========================================================== #
module "cidr_myip" {
  source              = "./modules/network/cidr_myip"
  u_allowed_cidr_myip = var.u_allowed_cidr_myip
}

# ========================================================== #
#   2.3. セキュリティグループ構築
# ========================================================== #
module "aws_security_group" {
  source              = "./modules/security/aws_security_group"
  u_vpc_id            = module.aws_vpc.id
  u_allowed_cidr_myip = module.cidr_myip.ip
}

# ========================================================== #
#   2.4. VPCエンドポイント構築
# ========================================================== #
module "aws_vpc_endpoint" {
  source                 = "./modules/network/aws_vpc_endpoint"
  u_vpc_id               = module.aws_vpc.id
  u_private_subnet_1a_id = module.aws_subnet.private_subnet_1a_id
  u_private_subnet_1c_id = module.aws_subnet.private_subnet_1c_id
  u_vpc_endpoint_sg_id = module.aws_security_group.prj_dev_vpc_endpoint_sg_id
  u_vpc_endpoint_private_route_table_id = module.aws_route_table.prj_dev_private_route_table_id
}

# ========================================================== #
#   2.5. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
# ========================================================== #
module "aws_key_pairs" {
  source             = "./modules/security/aws_key_pairs"
  u_key_name         = var.u_key_name
  u_private_key_name = var.u_private_key_name
  u_public_key_name  = var.u_public_key_name
}

# ========================================================== #
# 3. ALB + AutoScaling 構築
# ========================================================== #
#   3.1. 起動テンプレート作成
# ========================================================== #
module "aws_launch_template" {
  source             = "./modules/webserver/aws_launch_template"
  u_security_group_web_id = module.aws_security_group.sg_web_id
  u_private_subnet_1a_id = module.aws_subnet.private_subnet_1a_id
}

# ========================================================== #
#   3.2. ALB作成
# ========================================================== #
module "aws_lb" {
  source                 = "./modules/webserver/aws_lb"
  u_security_group_alb_id = module.aws_security_group.sg_alb_id
  u_public_subnet_1a_id = module.aws_subnet.public_subnet_1a_id
  u_public_subnet_1c_id = module.aws_subnet.public_subnet_1c_id
}

module "aws_lb_target_group" {
  source              = "./modules/webserver/aws_lb_target_group"
  u_vpc_id            = module.aws_vpc.id
}

module "aws_lb_listener" {
  source              = "./modules/webserver/aws_lb_listener"
  u_lb_arn            = module.aws_lb.arn
  u_lb_target_group_arn = module.aws_lb_target_group.arn
}

# ========================================================== #
#   3.3. Auto Scaling Group作成
# ========================================================== #
module "aws_autoscaling_group" {
  source              = "./modules/webserver/aws_autoscaling_group"
  u_private_subnet_1a_id = module.aws_subnet.private_subnet_1a_id
  u_private_subnet_1c_id = module.aws_subnet.private_subnet_1c_id
  u_launch_template_web_id = module.aws_launch_template.web_id
  u_launch_template_web_latest_version = module.aws_launch_template.web_latest_version
}

module "aws_autoscaling_attachment" {
  source              = "./modules/webserver/aws_autoscaling_attachment"
  u_autoscaling_group_id = module.aws_autoscaling_group.id
  u_lb_target_group_arn = module.aws_lb_target_group.arn
}






