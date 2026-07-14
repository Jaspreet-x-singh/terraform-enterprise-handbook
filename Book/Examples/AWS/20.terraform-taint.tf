# terraform taint is a command used in Terraform to manually mark a resource for recreation. When you taint a resource, Terraform will destroy and recreate it during the next apply operation, even if there are no changes to the resource's configuration. This can be useful for forcing a resource to be replaced, for example, if it is in an unhealthy state or if you want to test the creation of a new instance.

resource "aws_instance" "example" {
  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}

# Example of how to use terraform taint command
# After running terraform apply, you can use the following command to taint the aws_instance.example resource:
# terraform taint aws_instance.example