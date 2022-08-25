resource "aws_lb" "web_elb" {
  name               = "web-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    # module.aws_security_group.sg_alb_id
    var.u_security_group_alb_id
  ]
  subnets = [
    # module.aws_subnet.public_subnet_1a_id,
    # module.aws_subnet.public_subnet_1c_id
    var.u_public_subnet_1a_id,
    var.u_public_subnet_1c_id
  ]
}

output "arn" {
  value = "${aws_lb.web_elb.arn}"
}