terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "myserver" {
  ami           = "ami-0317b0f0a0144b137"
  instance_type = "t3.nano"
  tags = {
    Name = "Singh Sahab Server"
  }

}
