# outputs.tf
# Values printed after terraform apply
# Like a summary receipt after building your infrastructure

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true  # SECURITY: Don't print this in logs
}

output "cluster_region" {
  description = "AWS region"
  value       = var.region
}

output "configure_kubectl" {
  description = "Run this command to connect kubectl to your cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}