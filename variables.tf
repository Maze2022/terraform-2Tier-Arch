# ----------- root/variables.tf

variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}