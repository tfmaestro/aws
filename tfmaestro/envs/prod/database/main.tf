provider "aws" {
}
module "mysql_db" {
  source                 = "../../../modules/database"
  name                    = var.name
  region                 = var.region
  public_subnets         = var.public_subnets
  db_instance_identifier = var.db_instance_identifier
  db_username            = var.db_username
  db_password            = var.db_password
  allowed_ips            = var.allowed_ips
}
