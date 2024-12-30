provider "aws" {
  region = "us-east-1" 
}

module "kubernetes" {
  source = "../../../modules/kubernetes"
  cluster_count      = var.cluster_count
  region             = var.region
  node_min_count     = var.node_min_count
  node_max_count     = var.node_max_count
  trusted_ip_range   = var.trusted_ip_range
}