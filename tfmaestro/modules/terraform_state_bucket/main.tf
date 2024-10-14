resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "terraform-state-${var.environment}"
  force_destroy = var.force_destroy

  tags = {
    environment = var.environment
    purpose     = "tf-state"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    expiration {
      days = 90
    }

  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-state-${var.environment}"

  tags = {
    environment = var.environment
    purpose     = "state-logging"
  }
}

resource "aws_s3_bucket_logging" "terraform_state_logging" {
  bucket = aws_s3_bucket.terraform_state.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "logs_tf_state_${var.environment}/"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name                        = "${var.table_name}-${var.environment}"
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "LockID"
  deletion_protection_enabled = false
  attribute {
    name = "LockID"
    type = "S"
  }
}
