# ========================================================== #
# 起動テンプレート作成
# ========================================================== #
resource "aws_launch_template" "web" {
  name = "web"

  image_id = "ami-00d101850e971728d"
  iam_instance_profile {
    name = "EC2RoleforSSM"
  }
  instance_type = "t2.micro"
  key_name      = "hanson_key.pem"

  network_interfaces {
    security_groups = [var.u_security_group_web_id]
    subnet_id       = var.u_private_subnet_1a_id
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

output "web_id" {
  value = "${aws_launch_template.web.id}"
}

output "web_latest_version" {
  value = "${aws_launch_template.web.latest_version}"
}