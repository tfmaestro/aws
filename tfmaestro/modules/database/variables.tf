variable "name" {
  description = "The name of the VPC"
  type        = string
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

variable "allocated_storage" {
  description = "Allocated storage for the DB instance"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Master username for the DB instance"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the DB instance"
  type        = string
  sensitive   = true
}

variable "allowed_ips" {
  description = "List of allowed CIDR blocks for MySQL access"
  type        = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "database_name" {
  description = "The database name."
  type        = string
  default     = "tfmaestro-mysql-database"
}
