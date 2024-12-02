output "instance_ips" {
  description = "The internal IP addresses of the created instances"
  value       = { for instance in aws_instance.main : instance.id => instance.private_ip }
}

output "instance_public_ips" {
  description = "The public IP addresses of the created instances"
  value       = { for instance in aws_instance.main : instance.id => instance.public_ip }
}

output "instance_names" {
  description = "The names of the created instances"
  value       = { for instance in aws_instance.main : instance.id => instance.tags["Name"] }
}
