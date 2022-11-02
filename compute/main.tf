# ---- compute/main.tf

data "aws_ami" "ami_id" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "bastion_host_template" {
  name           = "asg-template"
  image_id       = data.aws_ami.ami_id
  instance_type  = var.instance_type
  vpc_security_group_ids = [var.bastion_host_sg]
  user_data      = var.user_data
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "lu_bastion_host_asg" {
  name               = "bastion-asg"
  vpc_zone_identifier = [var.public_subnets]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.bastion_host_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "webserver" {
  name           = "webserver"
  image_id       = data.aws_ami.ami_id
  instance_type  = var.instance_type
  vpc_security_group_ids = [var.webserver_sg]
}

resource "aws_autoscaling_group" "webserver_asg" {
  name               = "webserver_asg"
  vpc_zone_identifier = [var.private_subnets]
  desired_capacity   = 3
  max_size           = 4
  min_size           = 2

  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }
}

resource "aws_key_pair" "lu_key" {
  key_name   = var.key_name
  public_key = "file(var.public_key_path"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.id
  lb_target_group_arn    = var.lb_tg
}