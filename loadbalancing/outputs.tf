# -------- loadbalancing/outputs.tf

output "lb_tg" {
  value = aws_lb_target_group.lu_alb_tg.arn
}

output "alb_dns" {
  value = aws_lb.lu_alb.dns_name
}
