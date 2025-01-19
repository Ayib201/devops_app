provider "aws" {
  region = "eu-west-3c"
}

resource "aws_instance" "factorial_app" {
  ami           = "my-factorial-app-ami" # Remplacer par une image AMI appropriée
  instance_type = "t2.micro"
  key_name      = "terraformkey" # Remplacer par votre clé SSH

  tags = {
    Name = "FactorialAppInstance"
  }
}
