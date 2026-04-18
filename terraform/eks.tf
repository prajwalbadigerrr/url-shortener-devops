# eks.tf
# Creates your Kubernetes cluster on AWS
# Like hiring a team of servers to run your containers

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  # SECURITY: Enable envelope encryption for Kubernetes secrets
  # Your secrets are encrypted inside the cluster
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # SECURITY: Enable all control plane logging
  # Every action in your cluster gets logged to CloudWatch
  cluster_enabled_log_types = [
    "api",
    "audit",        # Who did what in the cluster
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets  # SECURITY: Nodes in private subnet

  # Worker nodes — the servers that actually run your containers
  eks_managed_node_groups = {
    main = {
      min_size       = var.min_nodes
      max_size       = var.max_nodes
      desired_size   = var.desired_nodes
      instance_types = [var.node_instance_type]

      # SECURITY: Use latest Amazon Linux 2 with all patches
      ami_type = "AL2_x86_64"

      # SECURITY: Encrypt all disk storage on nodes
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            encrypted             = true  # Disk encryption ON
            delete_on_termination = true
          }
        }
      }
    }
  }

  # SECURITY: Enable IAM Roles for Service Accounts
  # Pods get their own IAM roles instead of sharing node credentials
  enable_irsa = true
}