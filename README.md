# Week21_2Tier_Arc_Terraform

Create a highly available two-tier AWS architecture containing the following:
3 Public Subnets
3 Private Subnets
1 Bastion Host in a public subnet
Auto Scaling Group for Web Server (in private subnets)
Internet-facing Application Load Balancer targeting Web Server Auto Scaling Group
Deploy this using Terraform Cloud as a CI/CD tool to check your build.
Use module blocks for ease of use and re-usability.
