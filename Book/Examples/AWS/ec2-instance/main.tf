provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c9b1e7f"
  instance_type = "t2.micro"

  tags = {
    Name = "example-ec2"
  }
}

