output "application_url" {
  description = "URL of the deployed Node.js application"
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
