resource "aws_autoscaling_attachment" "mapping" {
  autoscaling_group_name = var.u_autoscaling_group_id
  lb_target_group_arn    = var.u_lb_target_group_arn
}