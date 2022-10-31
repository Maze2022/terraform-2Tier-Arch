# -------- loadbalancing/main.tf

resource "aws_lb_target_group" "lu-alb-tg" {
  name     = "lu-alb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
#   lifecyle {
#     ignore_changes = [name]
#   }
}

resource "aws_lb" "lu-alb" {
  name               = "lu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = var.public_subnets
}

# Create Load balancer listner rule
resource "aws_lb_listener" "lu-lb_lst" {
  load_balancer_arn = aws_lb.lu-alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lu-alb-tg.arn
  }
}

# #Load balancer-Target group attachment
# resource "aws_lb_target_group_attachment" "lu-alb" {
#   target_group_arn = aws_lb_target_group.alb-TG.arn
#   target_id        = aws_instance.Pub2a_ec2.id
#   port             = 80
# }

# #Load balancer-Target group attachment
# resource "aws_lb_target_group_attachment" "lu-alb2" {
#   target_group_arn = aws_lb_target_group.alb-TG.arn
#   target_id        = aws_instance.Pub2b_ec2.id
#   port             = 80
# }