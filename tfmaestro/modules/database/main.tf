terraform {
  required_providers {
    mysql = {
      source = "Giphy/mysql"
      version = "0.1.1"
    }
  }
}
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.name}-vpc"]
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Allow MySQL database access"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "public-subnet-group"
  subnet_ids = var.public_subnets
}

resource "aws_db_instance" "public_mysql" {
  identifier         = var.db_instance_identifier
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  allocated_storage   = var.allocated_storage
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.public_subnet_group.name 
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  skip_final_snapshot        = true

  tags = {
    Name = "MySQL database"
  }
}

provider "mysql" {
  endpoint = aws_db_instance.public_mysql.address
  username = var.db_username
  password = var.db_password
}

resource "mysql_database" "database" {
  name = var.database_name
}
