# terraform local values are a way to define and use variables that are local to a specific module or configuration. They allow you to create reusable values that can be referenced throughout your Terraform code, making it easier to manage and maintain your infrastructure as code. Local values can be defined using the locals block and can be used to store computed values, constants, or any other data that you want to reference multiple times within your configuration.

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Name = "security-team"
  }
}

locals {
  default_tags = {
    Environment  = "dev"
    Project      = "my-project"
    CreationDate = "date-${formatdate("YYYY-MM-DD", timestamp())}"
  }
}

resource "aws_security_group" "sg_01" {
  name = "app-firewall-sg"
  tags = merge(var.tags, local.default_tags)
}

resource "aws_security_group" "sg_02" {
  name = "db-firewall-sg"
  tags = merge(var.tags, local.default_tags)
}

# Example of how to use local values
# After running terraform apply, you can use the following command to display the tags of the security groups:
# terraform output sg_01_tags
# terraform output sg_02_tags