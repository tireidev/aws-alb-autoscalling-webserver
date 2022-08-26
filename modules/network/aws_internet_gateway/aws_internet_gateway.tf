# ========================================================== #
# IGW構築
# ========================================================== #
resource "aws_internet_gateway" "prj_dev_igw" {
  vpc_id = var.u_vpc_id
  tags = {
    Env = "dev"
    Name = "prj_dev_igw"
  }
}

output "id" {
  value = "${aws_internet_gateway.prj_dev_igw.id}"
}