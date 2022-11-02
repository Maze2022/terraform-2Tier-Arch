# -------- loadbalancing/outputs.tf

output "lb_tg" {
    value = aws_lb_target_group.lu-alb-tg.arn
}

output "alb_dns" {
    value = aws_lb.lu-alb.name
}