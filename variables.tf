# ----------- root/variables.tf

variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}