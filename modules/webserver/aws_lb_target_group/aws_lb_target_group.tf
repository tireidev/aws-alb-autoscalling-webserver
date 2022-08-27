# ========================================================== #
# ALBターゲットグループ作成
# ========================================================== #
resource "aws_lb_target_group" "target_group" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.u_vpc_id
}

output "arn" {
  value = "${aws_lb_target_group.target_group.arn}"
}