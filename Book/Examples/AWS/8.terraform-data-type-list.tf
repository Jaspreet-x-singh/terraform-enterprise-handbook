# terraform data type list is a collection of ordered values that can be of any data type, such as strings, numbers, booleans, or even other lists. In Terraform, lists are used to store and manage multiple values in a single variable, allowing you to easily iterate over them and reference specific elements by their index. Lists can be defined using the [] syntax or by using the list() function.


variable "username" {
  description = "The username for the IAM user"
  type        = string
  #default     = "lb-user"

}

resource "aws_iam_user" "lb" {
  name = var.username
}

variable "my-list" {
  description = "A list of strings"
  type        = list(string)
}

output "my-list-output" {
  value = var.my-list
}