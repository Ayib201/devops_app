output "instance_id" {
  value = aws_instance.factorial_app.id
}

output "public_ip" {
  value = aws_instance.factorial_app.public_ip
}
