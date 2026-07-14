# terraform conditional expressions are a way to evaluate a condition and return one of two values based on whether the condition is true or false. They allow you to create dynamic configurations that can adapt to different scenarios, such as different environments or regions. Conditional expressions are written using the syntax: condition ? true_value : false_value.

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region for the resources"
  type        = string
  default     = "us-west-2"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.environment == "dev" ? "t2.micro" : "t2.large"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.environment != "prod" ? "t2.micro" : "t2.large"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.environment == "dev" && var.region == "us-east-1" ? "t2.micro" : "t2.large"
}

output "instance_type" {
  value = aws_instance.myec2.instance_type
}

# Example of how to use conditional expressions
# After running terraform apply, you can use the following command to display the output value:
# terraform output instance_type