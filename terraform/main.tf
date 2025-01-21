provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dev_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Utilisez l'AMI appropriée pour votre région
  instance_type = "t2.micro"
  key_name = "Ubuntu"
  security_groups = ["mon site"]

  tags = {
    Name = "serveur web devops"
  }
docker pull julesbestdev176/factorial:latest
user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Installation de Docker et Docker Compose
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo docker pull julesbestdev176/factorial
  sudo docker run -d -p 8080:8080 --name factorial-app julesbestdev176/factorial

  # Cloner le repo contenant les fichiers docker-compose
  cd /home/ubuntu
  git clone https://github.com/Ayib201/devops_app
  sudo docker-compose up --build -d
EOF

}

output "instance_public_ip" {
  value = aws_instance.dev_instance.public_ip
}
