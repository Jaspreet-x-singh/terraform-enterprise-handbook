# Resource dependency in Terraform allows you to specify the order in which resources are created or destroyed. This is useful when one resource depends on the existence of another resource.

# Terraform resource dependency example
# This example demonstrates how to create a dependency between two resources in Terraform.

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"

  # This resource depends on the aws_instance resource being created first
  depends_on = [aws_instance.example]

  tags = {
    Name = "MyS3Bucket"
  }
}
