# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# AWS上のパブリックサブネットにNginxを構築する
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
#   2.1. MyIP取得
#   2.2. ネットワークACL構築
#   2.3. セキュリティグループ構築
#   2.4. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
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

resource "aws_launch_template" "foo" {
  name = "foo"

  image_id = "ami-00d101850e971728d"
  iam_instance_profile {
    name = "EC2RoleforSSM"
  }
  instance_type = "t2.micro"
  key_name      = "hanson_key.pem"

  network_interfaces {
    # associate_public_ip_address = true
    security_groups = [module.aws_security_group.sg_web_id]
    subnet_id       = module.aws_subnet.private_subnet_1a_id
  }

  placement {
    availability_zone = "ap-northeast-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/script.sh")
}


resource "aws_lb" "web_elb" {
  name               = "web-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    module.aws_security_group.sg_alb_id
  ]
  subnets = [
    module.aws_subnet.public_subnet_1a_id,
    module.aws_subnet.public_subnet_1c_id
  ]

  # health_check {
  #   timeout = 3
  #   interval = 30
  #   path = "/"
  #   port = "80"
  # }

  # listener {
  #   lb_port = 80
  #   lb_protocol = "http"
  #   instance_port = "80"
  #   instance_protocol = "http"
  # }

}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.aws_vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = [module.aws_subnet.private_subnet_1a_id, module.aws_subnet.private_subnet_1c_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = aws_launch_template.foo.id
    version = aws_launch_template.foo.latest_version
  }

  health_check_type = "ELB"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.bar.id
  lb_target_group_arn    = aws_lb_target_group.test.arn
}




