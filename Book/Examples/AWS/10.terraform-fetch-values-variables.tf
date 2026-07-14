# terraform variables are a way to parameterize your Terraform configurations, allowing you to define values that can be reused throughout your code. Variables can be defined with a name, type, description, and default value. They can be used to customize resource configurations, making your infrastructure code more flexible and easier to manage.

variable "list" {
  description = "A list of values"
  type        = list(string)
  default     = ["m5.large", "m5.xlarge", "t2.medium"]
}

variable "types" {
  description = "A map of values"
  type        = map(string)
  default = {
    us-west-1  = "t2.micro"
    us-west-2  = "t2.nano"
    ap-south-1 = "t2.small"
  }
}

resource "aws_instance" "myec2-map" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.types["us-west-2"]
}

resource "aws_instance" "myec2-list" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.list[1]
}