variable "cluster_name" {
  description = "Nazwa klastra EKS"
  type        = string
  default     = "tfmaestro-cluster-k8s"
}

variable "region" {
  description = "AWS region where the cluster will be created"
  type        = string
  default     = "us-west-2"
}

variable "k8s_version" {
  description = "The Kubernetes cluster version"
  type        = string
  default     = "1.30"
}

variable "node_min_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
}

variable "node_max_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
}

variable "trusted_ip_range" {
  description = "Trusted IP range for accessing the cluster"
  type        = set(string)
}

variable "cluster_count" {
  description = "Number of Kubernetes clusters to create"
  type        = number
}
