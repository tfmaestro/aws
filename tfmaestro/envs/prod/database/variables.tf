variable "name" {
  description = "The name of the VPC"
  type        = string
  default = "prod"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "db_instance_identifier" {
  description = "The DB instance identifier"
  type        = string
  default     = "public-mysql-db"
}

variable "db_username" {
  description = "Master username for the DB instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the DB instance"
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed CIDR blocks for MySQL access"
  type        = list(string)
}
