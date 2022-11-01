# --------compute/outputs.tf

output "webserver_asg" {
  value = aws_autoscaling_group.webserver
}