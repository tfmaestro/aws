variable "region" {
  description = "Region AWS, w którym ma zostać utworzony klaster"
  type        = string
}

variable "node_min_count" {
  description = "Minimalna liczba węzłów w grupie węzłów"
  type        = number
}

variable "node_max_count" {
  description = "Maksymalna liczba węzłów w grupie węzłów"
  type        = number
}

variable "trusted_ip_range" {
  description = "Zakres IP, który ma dostęp do API EKS"
  type        = set(string)
}

variable "cluster_count" {
  description = "Number of Kubernetes clusters to create"
  type        = number
}
