terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.6.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "allow on port 8080"

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_ami" "app_ami" {
  most_recent      = true
  name_regex       = "cocktails-app-*"
  owners           = ["self"]
}

resource "aws_instance" "web_app" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.app_ami.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
}