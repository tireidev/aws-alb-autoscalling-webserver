# ========================================================== #
# MyIP取得
# ========================================================== #
# http ifconfigはMyIPを取得するために必要な記載
data "http" "ifconfig" {
  url = "https://ifconfig.co/ip"
}

locals {
  u_current_ip        = chomp(data.http.ifconfig.body)
  u_allowed_cidr_myip = (var.u_allowed_cidr_myip == null) ? "${local.u_current_ip}/32" : var.u_allowed_cidr_myip
}

output "ip" {
  value = "${local.u_allowed_cidr_myip}"
}