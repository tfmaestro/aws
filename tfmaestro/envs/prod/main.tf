module "vpc" {
  source      = "../../modules/vpc"
  name        = var.environment
  description = "Production environment VPC"
  cidr_block  = "10.0.0.0/16"

  public_subnets = {
    "${var.environment}-public-subnet-01" = {
      cidr                    = "10.0.10.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
    },
    "${var.environment}-public-subnet-02" = {
      cidr                    = "10.0.11.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
    }
  }

  private_subnets = {
    "${var.environment}-private-subnet-01" = {
      cidr                    = "10.0.12.0/24"
      availability_zone       = "us-east-1c"
      map_public_ip_on_launch = false
    },
    "${var.environment}-private-subnet-02" = {
      cidr                    = "10.0.13.0/24"
      availability_zone       = "us-east-1d"
      map_public_ip_on_launch = false
    }
  }
}
