variable "environment" {
  type = string
}
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}
variable "region" {
  type = string
}
variable "ec2_instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    instance_type        = string
    instance_description = optional(string)
    availability_zone    = string
    ip_host              = number
  }))
}
variable "ami_id" {
  description = "AMI ID for the EC2 instances (for Ubuntu)"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}
variable "ssh_key_name" {
  description = "Admin user SSH key"
  type        = string
  default     = "kasia"
}

variable "allow_firewall_rules" {
  description = "Map of allow firewall rules."
  type = map(object({
    protocol         = string
    ports            = optional(list(string))
    priority         = number
    description      = string
    source_ip_ranges = list(string)
  }))
}