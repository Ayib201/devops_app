provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dev_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Utilisez l'AMI appropriée pour votre région
  instance_type = "t2.micro"
  key_name = "Ubuntu"
  security_groups = ["sg-007cf4ad48e36d5ef"]

  tags = {
    Name = "serveur web devops"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y

  # Installation de Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    apt-get install -y maven
    # Cloner le repo contenant les fichiers docker-compose
    cd /home/ubuntu
    git clone https://github.com/Ayib201/devops_app
    cd devops_app
    cd backend
    mvn clean install
    cd ..
    sudo docker-compose up --build -d
  EOF
}

output "instance_public_ip" {
  value = aws_instance.dev_instance.public_ip
}
