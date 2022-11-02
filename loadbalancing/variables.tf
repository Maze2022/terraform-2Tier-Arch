#------- loadbalancing/variables.tf

variable "vpc_id" {}
variable "public_subnets" {}
variable "lb_sg" {}
variable "tg_port" {}
variable "tg_protocol" {}
variable "listener_port" {}
variable "listener_protocol" {}