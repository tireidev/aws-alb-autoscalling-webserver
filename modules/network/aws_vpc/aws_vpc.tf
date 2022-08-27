# ========================================================== #
# VPC構築
# ========================================================== #
resource "aws_vpc" "default" {
  cidr_block       = var.u_vpc_ip_ip4
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Env = "dev"
    Name = "prj_dev_vpc"
  }

}

output "id" {
  value = "${aws_vpc.default.id}"
}