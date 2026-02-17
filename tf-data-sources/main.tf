terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "name" {
  
}

output "aws_ami" {
  value = data.aws_ami.name
}

resource "aws_instance" "myserver" {
  ami           = "ami-0317b0f0a0144b137"
  instance_type = "t3.nano"
  tags = {
    Name = "DataSource Server"
  }
}