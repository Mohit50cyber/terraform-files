terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1"
    }
    random ={
        source = "hashicorp/random"
        version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "random_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "demo-singh-12345"
}

resource "aws_s3_object" "bucket-data" {
  bucket = aws_s3_bucket.demo-bucket.bucket  
  source = "./myfiles.txt"
  key = "mydata.txt"
}

output "name" {
  value = random_id.random_id.b64_url
}