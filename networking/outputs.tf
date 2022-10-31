# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.Week21_vpc.id
}

output "public_subnets" {
  value = aws_subnet.lu-public_subnet.*.id
}

output "public_sg" {
  value = aws_security_group.lu_sg.id
}

