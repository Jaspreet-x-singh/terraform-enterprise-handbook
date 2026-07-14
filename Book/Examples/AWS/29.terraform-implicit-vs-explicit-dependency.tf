# Terraform explicit and implicit dependency refers to the way resources are linked together in a Terraform configuration. Implicit dependencies are automatically inferred by Terraform based on resource references, while explicit dependencies are defined using the `depends_on` argument.

# Implicit Dependency Example
# In this example, the aws_s3_bucket resource implicitly depends on the aws_instance resource because it references the aws_instance resource in its configuration.
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"

  # This resource implicitly depends on the aws_instance resource by referencing its attributes (e.g., aws_instance.example.id)
  tags = {
    Name = aws_instance.example.id
  }
}

# Explicit Dependency Example
# In this example, the aws_s3_bucket resource explicitly depends on the aws_instance resource using the `depends_on` argument.
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"

  # This resource explicitly depends on the aws_instance resource
  depends_on = [aws_instance.example]

  tags = {
    Name = "MyS3Bucket"
  }
}
