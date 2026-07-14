terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# resource "aws_instance" "ec2_instance" {
#   ami           = "ami-095bd4a11ce8746c0" # Singapore region
#   instance_type = "t2.micro"
#   tags = {
#     Name        = "MyFirstEC2Instance"
#     Environment = "Development"
#   }
# }
