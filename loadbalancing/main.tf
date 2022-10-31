# -------- loadbalancing/main.tf

# --- Target group
resource "aws_lb_target_group" "lu-alb-TG" {
  name     = "lu-alb-TG"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
}

# Load balancer
resource "aws_lb" "my-aws-alb" {
  name               = "lu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = var.public_subnets
}

# # Create Load balancer listner rule
# resource "aws_lb_listener" "lb_lst" {
#   load_balancer_arn = aws_lb.my-aws-alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb-TG.arn
#   }
# }

# #Load balancer-Target group attachment
# resource "aws_lb_target_group_attachment" "my-aws-alb" {
#   target_group_arn = aws_lb_target_group.alb-TG.arn
#   target_id        = aws_instance.Pub2a_ec2.id
#   port             = 80
# }

# #Load balancer-Target group attachment
# resource "aws_lb_target_group_attachment" "my-aws-alb2" {
#   target_group_arn = aws_lb_target_group.alb-TG.arn
#   target_id        = aws_instance.Pub2b_ec2.id
#   port             = 80
# }