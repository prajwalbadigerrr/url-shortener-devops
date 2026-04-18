# vpc.tf
# Creates a secure network for your infrastructure
# Like building the walls and rooms of your house before putting furniture in

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"  # Your private IP range

  # Spread across 2 availability zones = high availability
  # If one AWS data center goes down, the other keeps running
  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true   # Private servers can reach internet
  single_nat_gateway   = true   # One NAT = cheaper for learning
  enable_dns_hostnames = true

  # SECURITY: Private subnets for worker nodes
  # Nodes are NOT directly exposed to internet
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}