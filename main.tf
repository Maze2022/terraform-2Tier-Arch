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
  source            = "./loadbalancing"
  lb_sg             = module.networking.lb_sg
  public_subnets    = module.networking.public_subnets
  vpc_id            = module.networking.vpc_id
  tg_port           = 80
  tg_protocol       = "HTTP"
  listener_port     = 80
  listener_protocol = "HTTP"
  # webserver_asg     = module.compute.webserver_asg
}

module "compute" {
  source = "./compute"
  instance_type = "t2.micro"
  public_subnets = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  webserver_sg = module.networking.webserver_sg
  bastion_host_sg = module.networking.bastion_host_sg
  key_name =        "ec2Key"
  user_data = filebase64("./userdata.sh")
  lb_tg = module.loadbalancing.lb_tg
}