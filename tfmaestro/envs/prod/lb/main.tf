module "lb" {
  source = "../../../modules/lb"
  ec2_instance_ips = var.ec2_instance_ips
}
