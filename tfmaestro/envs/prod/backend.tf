terraform {
    backend "s3" {
        bucket = "<BUCKET_ID>"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}