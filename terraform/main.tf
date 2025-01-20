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

user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Installation de Docker et Docker Compose
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo apt-get install -y wget unzip
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # Installation de Maven
  wget https://downloads.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
  sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz -C /opt/
  sudo ln -s /opt/apache-maven-3.9.9/bin/mvn /usr/bin/mvn

  # Configuration JAVA_HOME
  export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
  export PATH=$JAVA_HOME/bin:$PATH

  # Cloner le repo contenant les fichiers docker-compose
  cd /home/ubuntu
  git clone https://github.com/Ayib201/devops_app
  sudo chown -R ubuntu:ubuntu /home/ubuntu/devops_app

  # Construction du projet avec Maven
  cd devops_app/backend
  sudo apt install -y openjdk-21-jdk
  sudo mvn clean install

  # Lancer Docker Compose
  cd ..
  sudo docker-compose up --build -d
EOF

}

output "instance_public_ip" {
  value = aws_instance.dev_instance.public_ip
}