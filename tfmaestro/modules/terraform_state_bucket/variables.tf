variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "The AWS region where the bucket will be created"
  type        = string
  default     = "us-east-1"
}

variable "log_bucket_name" {
  description = "The bucket to store access logs"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Boolean that indicates all objects should be deleted from the bucket when the bucket is destroyed."
  type        = bool
  default     = false
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "terraform-remote-state"
}

variable "block_public_acls" {
  description = "Whether to block public ACLs for the S3 bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs for the S3 bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether to restrict access to public buckets."
  type        = bool
  default     = true
}
