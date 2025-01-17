variable "ec2_instance_ips" {
  description = "List of EC2 instance IPs to attach to the load balancer target group"
  type        = list(string)
}
