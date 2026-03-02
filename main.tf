terraform {
    backend "s3" {
      bucket = "terraform-sandeep0088"
      key    = "elk/terraform.tfstate"
      region = "us-east-1"
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}


resource "aws_instance" "elk" {
  ami = "ami-0220d79f3f480ecf5"
  vpc_security_group_ids = [ "sg-0945bfb9e18b240e0" ]
  instance_type = "t3.small"

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type             = "persistent"
      instance_interruption_behavior = "stop"
    }
  }

  tags = {
    Name = "elk"
  }

}
# Security Group that allows SSH (port 22) and all outbound traffic
resource "aws_security_group" "elk_sg" {
  name        = "elk_security_group"
  description = "Allow SSH access"
  vpc_id      = "sg-0945bfb9e18b240e0"  # replace with your VPC ID

  # SSH ingress rule
  ingress {
    description = "Allow SSH from anywhere (change for security)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # allow anywhere; replace with your IP range for better security
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "ansible" {
  triggers = {
    id = aws_instance.elk.id
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.elk.private_ip}, elk.yml -e ansible_user=ec2-user -e ansible_password=DevOps321"

  }

}