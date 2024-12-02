output "instance_ips" {
  description = "The internal IP addresses of the created instances"
  value       = module.ec2_firewall.instance_ips
}
output "instance_public_ips" {
  description = "The public IP addresses of the created instances"
  value       = module.ec2_firewall.instance_public_ips
}
output "instance_names" {
  description = "The names of the created instances"
  value       = module.ec2_firewall.instance_names
}
