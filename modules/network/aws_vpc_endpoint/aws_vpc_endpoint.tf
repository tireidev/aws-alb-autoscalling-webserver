# ========================================================== #
# VPC Endpoint用IAMポリシー
# ========================================================== #
data  "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

# ========================================================== #
# VPC Endpoint構築(com.amazonaws.ap-northeast-1.ssm)
# ========================================================== #
resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = "Interface"
  vpc_id            =  var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_private_subnet_1a_id, var.u_private_subnet_1c_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

# ========================================================== #
# VPC Endpoint構築(com.amazonaws.ap-northeast-1.ssmmessages)
# ========================================================== #
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_private_subnet_1a_id, var.u_private_subnet_1c_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

# ========================================================== #
# VPC Endpoint構築(com.amazonaws.ap-northeast-1.ec2messages)
# ========================================================== #
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_private_subnet_1a_id, var.u_private_subnet_1c_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

# ========================================================== #
# VPC Endpoint構築(com.amazonaws.ap-northeast-1.s3)
# ========================================================== #
resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids = [
    var.u_vpc_endpoint_private_route_table_id
  ]
}