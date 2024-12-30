output "eks_cluster_info" {
  value = [
    for cluster in aws_eks_cluster.primary : {
      name    = cluster.name
      address = cluster.endpoint
    }
  ]
}