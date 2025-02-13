
resource "aws_instance" "dev_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Vérifiez l'AMI pour la région
  instance_type = "t2.micro"
  key_name      = "Ubuntu"
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
    docker pull ayibgoat/devopsapp
    sudo docker run -d -p 80:80 ayibgoat/devopsapp
    sudo docker start $(sudo docker ps -a -q)
  EOF
}

