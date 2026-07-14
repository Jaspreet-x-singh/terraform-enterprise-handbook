# terraform validate is a command used in Terraform to check the syntax and validity of the Terraform configuration files. It ensures that the configuration is syntactically correct and that all required variables and resources are properly defined. This command helps catch errors before applying the configuration, preventing potential issues during deployment.

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  #sky           = "blue"

  tags = {
    Name = "MyEC2Instance"
  }
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = "MyEC2Instance"
  }
}

# Example of how to use terraform validate command
# After running terraform init, you can use the following command to validate the configuration:
# terraform validate