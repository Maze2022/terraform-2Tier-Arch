# --------- root/main.tf

module "networking" {
  source               = "./networking"
  vpc_cidr             = "172.33.0.0/16"
  access_ip            = var.access_ip
  private_subnet_count = 3
  public_subnet_count  = 3
  private_cidrs        = [for i in range(1, 6, 2) : cidrsubnet("172.33.0.0/16", 8, i)]
  public_cidrs         = [for i in range(2, 7, 2) : cidrsubnet("172.33.0.0/16", 8, i)]

  # enable_nat_gateway = true
  # enable_vpn_gateway = true
}

module "loadbalancing" {
  source = "./loadbalancing"
  public_sg = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  vpc_id = module.networking.vpc_id
  tg_port = 80
  tg_protocol = "HTTP"
}