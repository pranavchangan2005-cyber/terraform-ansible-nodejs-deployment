
provider "aws" {
  region = "ap-south-1"
}
variable "ssh_allowed_cidr" {
  description = "Public IP range allowed to SSH into EC2, e.g. 203.0.113.10/32"
  type        = string
}

resource "aws_instance" "app_server" {
  ami                    = "ami-082a1ff88c78c6290"
  instance_type          = "t3.micro"
  key_name               = "ansible-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  
  provisioner "local-exec" {
    command = <<-EOT
      set -e

      printf '[webservers]\n%s ansible_user=ubuntu ansible_ssh_private_key_file=%s/ansible-key.pem\n' '${self.public_ip}' '${path.module}' > '${path.module}/inventory.ini'

      chmod 400 '${path.module}/ansible-key.pem'

      for i in $(seq 1 60); do
        if ssh -i '${path.module}/ansible-key.pem' -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 -o BatchMode=yes ubuntu@${self.public_ip} true; then
          break
        fi
        if [ "$i" -eq 60 ]; then
          echo "SSH did not become available within 5 minutes"
          exit 1
        fi
        sleep 5
      done

      ansible-playbook -i '${path.module}/inventory.ini' '${path.module}/playbook.yml' --private-key '${path.module}/ansible-key.pem' -f 1
    EOT
  }
 
}

resource "aws_security_group" "app_sg" {
  name        = "ansible-nodejs-sg"
  description = "Allow SSH and Node.js application access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

