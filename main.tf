terraform {
  backend "s3" {
    bucket = "terraform-state-bucketfff"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "flask_app" {
  ami                    = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI (gratis)
  instance_type          = "t2.micro"              # Tipo de instancia gratis dentro de la capa gratuita
  key_name               = "dev-key"               # Nombre de tu par de claves para SSH
  vpc_security_group_ids = ["${aws_security_group.flask_app_sg.id}"]
  user_data              = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo amazon-linux-extras install docker -y
                  sudo systemctl enable docker.service
                  sudo systemctl start docker.service
                  sudo usermod -a -G docker ec2-user
                  EOF
  tags = {
    Name = "flask_app_instance"
  }
}

resource "aws_security_group" "flask_app_sg" {
  name_prefix = "flask_app_sg"

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask_app_sg"
  }
}

resource "aws_ecr_repository" "flask-repo" {
  name                 = "flask-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "public_ip" {
  value = aws_instance.flask_app.public_ip
}
