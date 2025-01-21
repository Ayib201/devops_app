provider "aws" {
  region = "eu-west-3"
  access_key = "AKIA6K5V7MK7WARAK34Y"
  secret_key = "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"
}

resource "aws_instance" "dev_instance" {
  ami           = "ami-06e02ae7bdac6b938"  # Vérifiez l'AMI pour la région
  instance_type = "t2.micro"
  key_name      = ""                # Assurez-vous que cette clé SSH existe
  security_groups = ["mon site"]          # Groupe de sécurité avec règles appropriées

  tags = {
    Name = "serveur web devops"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Installer Docker
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl enable docker
    sudo systemctl start docker

    # Tirer et exécuter l'image Docker
    sudo docker pull julesbestdev176/factorial
    sudo docker run -d -p 8080:8080 --name factorial-app julesbestdev176/factorial

    # Cloner le dépôt Git et exécuter docker-compose
    cd /home/ubuntu
    git clone https://github.com/Ayib201/devops_app
    cd devops_app
    sudo docker compose up --build -d
  EOF
}

output "instance_public_ip" {
  value = aws_instance.dev_instance.public_ip
}
