resource "aws_autoscaling_group" "group" {
  vpc_zone_identifier = [var.u_private_subnet_1a_id, var.u_private_subnet_1c_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = var.u_launch_template_web_id
    version = var.u_launch_template_web_latest_version
  }

  health_check_type = "ELB"
}

output "id" {
  value = "${aws_autoscaling_group.group.id}"
}