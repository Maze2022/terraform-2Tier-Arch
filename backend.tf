terraform {
  backend "remote" {
    organization = "project-terraform"

    workspaces {
      name = "2Tier-dev"
    }
  }
}