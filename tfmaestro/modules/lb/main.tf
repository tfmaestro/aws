data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name" 
    values = ["prod-vpc"]
  }
}

data "aws_subnet" "public_subnet" {
  for_each = toset([
    "prod-public-subnet-01",
    "prod-public-subnet-02"
  ])
  filter {
    name   = "tag:Name" 
    values = [each.key]
  }
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_security_group" "firewall_rules" {
  filter {
    name   = "tag:Name" 
    values = ["ec2-security-group"]
  }
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_lb" "external-alb" {
  name               = "tfmaestro-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.firewall_rules.id]
  subnets            = [for subnet in data.aws_subnet.public_subnet : subnet.id]
}

resource "aws_lb_target_group" "target_elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
  target_type = "ip"
  health_check {
    path     = "/health"
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  for_each = toset(var.ec2_instance_ips)
  target_group_arn = aws_lb_target_group.target_elb.arn
  target_id        = each.value
  port             = 80
  depends_on = [
    aws_lb_target_group.target_elb
  ]
}

resource "aws_lb_listener" "listener_elb" {
  load_balancer_arn = aws_lb.external-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_elb.arn
  }
}
