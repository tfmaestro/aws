output "lb_dns_name" {
  description = "DNS of Load balancer"
  value       = aws_lb.external-alb.dns_name
}