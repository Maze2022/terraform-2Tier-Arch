# ------- networking/variables.tf
variable "vpc_cidr"  {
    type = string
}

variable "public_cidrs" {
    type = list
}

variable "private_cidrs" {
    type = list
}

variable "public_subnet_count" {
    type = number
}

variable "private_subnet_count" {
    type = number
}

variable "access_ip" {
    type = number 
}