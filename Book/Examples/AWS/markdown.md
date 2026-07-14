Terraform Concepts Detailed Guide

This document provides detailed explanations and examples for each Terraform file in your learning directory. It is designed as a comprehensive reference for understanding Terraform fundamentals, meta‑arguments, data types, debugging, and advanced constructs.

1. first_ec2.tf — Basic Resource Creation

Terraform resources define infrastructure objects.

Concept

A resource block tells Terraform to create and manage an infrastructure component.

Example

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "FirstEC2"
  }
}

2. nsg.tf — Network Security Group

Defines inbound/outbound rules for controlling traffic.

Example (Azure)

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

3. elastic-ip.tf — Elastic IP Assignment

Assigns a static IP to an EC2 instance.

Example

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_eip_association" "example" {
  instance_id   = aws_instance.example.id
  allocation_id = aws_eip.example.id
}

4. cross-reference.tf — Cross Resource Referencing

Use attributes from one resource inside another.

Example

resource "aws_security_group" "web_sg" {
  name = "web-sg"
}

resource "aws_instance" "web" {
  ami                    = "ami-123456"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
}

5. output.tf — Output Values

Outputs display useful information after terraform apply.

Example

output "instance_ip" {
  value = aws_instance.web.public_ip
}

6. variables.tf — Declaring Variables

Variables make Terraform reusable.

Example

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

7. dev.terraform.tfvars — Environment Variable Values

Provides values for variables.

Example

instance_type = "t3.medium"
region        = "ap-southeast-2"

8. data-type-list.tf — List Data Type

Lists store ordered values.

Example

variable "subnets" {
  type    = list(string)
  default = ["subnet-123", "subnet-456"]
}

9. data-type-map.tf — Map Data Type

Maps store key-value pairs.

Example

variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Owner       = "Jaspreet"
  }
}

10. fetch-values-variables.tf — Using Variables

Reference variables inside resources.

Example

resource "aws_instance" "example" {
  instance_type = var.instance_type
  ami           = var.ami_id
}

11. count-meta-argument.tf — Creating Multiple Resources

count creates multiple instances of a resource.

Example

resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-123456"
  instance_type = "t2.micro"
}

12. count-index.tf — Using count.index

count.index provides the index of each instance.

Example

resource "aws_instance" "web" {
  count = 3

  tags = {
    Name = "web-${count.index}"
  }
}

13. conditional-expressions.tf — Conditional Logic

Choose values based on conditions.

Example

instance_type = var.env == "prod" ? "t3.large" : "t2.micro"

14. local-values.tf — Local Variables

Locals store reusable expressions.

Example

locals {
  common_tags = {
    Environment = var.env
    Owner       = "Jaspreet"
  }
}

15. data-sources.tf — Data Sources

Fetch existing resources.

Example

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

16. debugging.tf — Debugging Terraform

Use logs and console.

Example

terraform console
TF_LOG=DEBUG terraform apply

17. terraform-fmt.tf — Formatting Code

Formats Terraform files.

Example

terraform fmt

18. dynamic-blocks.tf — Dynamic Blocks

Generate nested blocks dynamically.

Example

resource "aws_security_group" "example" {
  dynamic "ingress" {
    for_each = var.rules

    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }
}

19. terraform-validate.tf — Validate Configuration

Checks syntax and structure.

Example

terraform validate

20. terraform-taint.tf — Force Resource Recreation

Marks a resource for recreation.

Example

terraform taint aws_instance.web

21. splat-expression.tf — Splat Expressions

Extract attributes from multiple resources.

Example

output "instance_ids" {
  value = aws_instance.web[*].id
}

22. terraform-graph.tf — Dependency Graph

Visualizes resource dependencies.

Example

terraform graph | dot -Tsvg > graph.svg

23. save-plan-to-file.tf — Save Terraform Plan

Save and reuse execution plans.

Example

terraform plan -out=tfplan
terraform apply tfplan

24. terraform-output.tf — Output Command

Displays output values.

Example

terraform output instance_ip

25. resource-targetting.tf — Target Specific Resources

Apply changes only to selected resources.

Example

terraform apply -target=aws_instance.web

26. terraform-zipmap.tf — zipmap Function

Combines two lists into a map.

Example

locals {
  names = ["dev", "prod"]
  ids   = ["subnet-123", "subnet-456"]

  env_map = zipmap(local.names, local.ids)
}

27. Common Terraform Meta-Arguments

| Meta-Argument | Purpose                                   | Example                                                      |
| ------------- | ----------------------------------------- | ------------------------------------------------------------ |
| `count`       | Creates multiple instances of a resource. | `count = 2`                                                  |
| `for_each`    | Creates resources from a map or set.      | `for_each = toset(["dev", "prod"])`                          |
| `depends_on`  | Specifies explicit dependencies.          | `depends_on = [aws_vpc.main]`                                |
| `provider`    | Uses a specific provider configuration.   | `provider = aws.us_east_1`                                   |
| `lifecycle`   | Controls resource lifecycle behavior.     | `ignore_changes`, `prevent_destroy`, `create_before_destroy` |

resource "aws_instance" "ec2_instance" {

  # Meta-arguments
  count      = 2
  provider   = aws
  depends_on = []

  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"

  tags = {
    Name        = "MyFirstEC2Instance-${count.index}"
    Environment = "Testing"
  }

  lifecycle {
    ignore_changes        = [tags]
    # create_before_destroy = true
    # prevent_destroy       = true
  }
}

resource "aws_instance" "ec2_instance" {
  for_each = toset(["dev", "test"])

  ami           = "ami-095bd4a11ce8746c0"
  instance_type = "t2.micro"

  tags = {
    Name = each.key
  }
}

End of Document