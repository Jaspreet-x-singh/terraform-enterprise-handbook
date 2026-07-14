# terraform output is a feature in Terraform that allows you to display the values of output variables defined in your Terraform configuration. Outputs are useful for providing information about the resources you've created, such as their IP addresses, DNS names, or other important details that might be needed for other systems or for manual verification.

resource "aws_iam_user" "example" {
  name  = "iamuser.${count.index + 1}"
  count = 3
}

output "iam_user_names" {
  value       = aws_iam_user.example[*].name
  description = "The names of the IAM users created."
}

output "iam_user_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs of the IAM users created."
}

# Example of how to use terraform output command
# After running terraform apply, you can use the following command to display the output values:
# terraform output iam_user_names

