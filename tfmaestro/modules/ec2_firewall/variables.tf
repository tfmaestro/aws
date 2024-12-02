variable "ec2_instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    instance_type        = string
    instance_description = optional(string)
    availability_zone    = string
    ip_host              = number
  }))
}

variable "environment" {
  description = "Type of environment"
  type        = string
  default     = "prod"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}

variable "network_name" {
  description = "Network name for the security group"
  type        = string
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
variable "ssh_key_name" {
  description = "Admin user SSH key"
  type        = string
  default     = "kasia"
}

variable "associate_public_ip_address" {
  description = "Enable external IP"
  type        = bool
  default     = true
}
