resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.u_lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.u_lb_target_group_arn
  }
}