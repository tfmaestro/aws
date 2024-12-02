data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-vpc"]
  }
}
data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-public-subnet-01"]
  }
  vpc_id = data.aws_vpc.vpc.id
}
resource "aws_security_group" "firewall_rules" {
  name        = "${var.network_name}-allow"
  description = "Allow rules for ${var.network_name}"
  vpc_id      = data.aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.allow_firewall_rules
    content {
      from_port   = (ingress.value.protocol == "icmp") ? 0 : tonumber(lookup(ingress.value, "ports", [0])[0])
      to_port     = (ingress.value.protocol == "icmp") ? 0 : tonumber(lookup(ingress.value, "ports", [0])[0])
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.source_ip_ranges
      description = ingress.value.description
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "main" {
  for_each        = var.ec2_instances
  subnet_id       = data.aws_subnet.public_subnet.id
  private_ips     = [cidrhost(var.subnet_cidr, each.value.ip_host)]
  security_groups = [aws_security_group.firewall_rules.id]
}

resource "aws_key_pair" "kasia_key" {
  key_name   = "kasia-tf"
  public_key = file("${path.module}/ssh/kasia_key.pub")
}

resource "aws_instance" "main" {
  for_each          = var.ec2_instances
  ami               = var.ami_id
  instance_type     = each.value.instance_type
  availability_zone = each.value.availability_zone
  key_name          = aws_key_pair.kasia_key.key_name

  tags = {
    Name        = each.key
    Description = try(each.value.instance_description, null)
  }

  user_data = <<-EOF
              #!/bin/bash

              echo "Aktualizacja pakietów..."
              apt-get update -y

              echo "Instalacja narzędzi do analizy sieci (net-tools)..."
              apt-get install -y net-tools
              EOF

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.main[each.key].id
  }
}
