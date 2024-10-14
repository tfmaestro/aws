module "terraform_state_bucket" {
  source      = "../../modules/terraform_state_bucket"
  environment = var.environment
  region      = var.region
}