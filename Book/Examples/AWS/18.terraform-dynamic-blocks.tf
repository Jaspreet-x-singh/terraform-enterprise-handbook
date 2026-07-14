# dynamic blocks in Terraform allow you to generate multiple nested blocks within a resource or module based on a collection of values. This is useful when you want to create multiple similar configurations without duplicating code. Dynamic blocks are defined using the dynamic keyword, and they can be used to iterate over lists or maps to create multiple instances of a block.

# Before
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Demo security group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "App security group"
  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# After

variable "security_groups" {
  description = "A list of security group names"
  type        = list(number)
  default     = [8200, 8300, 8400]
}

resource "aws_security_group" "security_group" {
  name        = "app-dynamic-rules-sg"
  description = "Security group with dynamic ingress rules"
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Example of how to use dynamic blocks
# After running terraform apply, you can use the following command to display the security group rules:
# terraform output security_group_rules
# dynamic blocks are particularly useful when you have a variable number of similar configurations to create, as they allow you to avoid repetitive code and make your Terraform configuration more maintainable.

