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
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
    }
  }

  tags = {
    Name = "elk"
  }

}

resource "null_resource" "ansible" {
  triggers = {
    id = aws_instance.elk.id
  }

  provisioner "local-exec" {
    command = <<EOF
      ansible-playbook -i ${aws_instance.elk.private_ip}, elk.yml -e ansible_user=ec2-user -e ansible_password=DevOps321
EOF
  }

}