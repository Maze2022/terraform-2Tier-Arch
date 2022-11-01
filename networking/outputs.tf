# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.Week21_vpc.id
}

output "public_subnets" {
  value = aws_subnet.lu_public_subnets.*.id
}

output "private_subnets" {
  value = aws_subnet.lu_private_subnets.*.id
}

output "bastion_host_sg" {
  value = aws_security_group.bastion_pub_sg.id
}

output "webserver_sg" {
  value = aws_security_group.webserver_priv_sg.id
}

output "lb_sg" {
  value = aws_security_group.lb_sg.id
}
