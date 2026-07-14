# terraform resource targeting is a feature in Terraform that allows you to apply changes to specific resources within your configuration, rather than applying changes to the entire configuration. This can be useful when you want to make changes to a specific resource without affecting other resources, or when you want to test changes in isolation.

resource "aws_iam_user" "example" {
  name  = "iamuser.${count.index + 1}"
  count = 3
}

resource "aws_security_group" "prod" {
  name = "prod-sg"
}

resource "local_file" "example" {
  content  = "This is an example file."
  filename = "${path.module}/example.txt"
}

# example of resource targeting
# to apply changes only to the aws_iam_user.example resource, you can use the following
# terraform apply -target=aws_iam_user.example
