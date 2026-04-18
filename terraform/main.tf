# main.tf
# This file tells Terraform WHAT to build

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Pinned version = secure
    }
  }

  # SECURITY: Store terraform state in S3, not on your laptop
  # State file contains sensitive info about your infrastructure
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "url-shortener/terraform.tfstate"
  #   region = "ap-south-1"
  #   encrypt = true  # SECURITY: Encrypt state file at rest
  # }
  # Commented out for now, we'll enable after creating S3 bucket
}

provider "aws" {
  region = var.region

  # SECURITY: Never hardcode credentials here
  # Terraform automatically reads from ~/.aws/credentials
  # which was set up by `aws configure`

  default_tags {
    tags = {
      Project     = "url-shortener-devops"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}