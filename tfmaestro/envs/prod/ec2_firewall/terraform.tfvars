environment = "prod"
name_prefix = "tfmaestro"
region      = "us-east-1"
ami_id      = "ami-07593001243a00d0a"
subnet_cidr = "10.0.10.0/24"

ec2_instances = {
  "tfmaestro-web-app-01" = {
    instance_type        = "t2.micro"
    availability_zone    = "us-east-1a"
    instance_description = "Web application"
    ip_host              = 4
  }
  "tfmaestro-web-app-02" = {
    instance_type        = "t2.micro"
    availability_zone    = "us-east-1a"
    instance_description = "Web application"
    ip_host              = 5
  }
}

allow_firewall_rules = {
  "allow-http" = {
    protocol         = "tcp"
    ports            = ["80"]
    priority         = 1000
    description      = "Allow http communication."
    source_ip_ranges = ["0.0.0.0/0"]
  }
  "allow-https" = {
    protocol         = "tcp"
    ports            = ["443"]
    priority         = 1001
    description      = "Allow https communication."
    source_ip_ranges = ["0.0.0.0/0"]
  }
  "allow-ssh-vpn" = {
    protocol         = "tcp"
    ports            = ["22"]
    priority         = 1002
    description      = "Allow ssh communication via VPN."
    source_ip_ranges = ["<TWOJE_IP>/32"]
  }
  "allow-icmp" = {
    protocol         = "icmp"
    priority         = 2000
    description      = "Allow ICMP."
    source_ip_ranges = ["0.0.0.0/0"]
  }
}