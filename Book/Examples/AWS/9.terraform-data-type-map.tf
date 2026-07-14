# terraform data type map is a collection of key-value pairs where each key is unique and maps to a specific value. In Terraform, maps are used to store and organize related data, allowing you to easily access and reference values based on their keys. Maps can be defined using the map() function or by using the {} syntax, and they can contain various data types such as strings, numbers, booleans, lists, or even other maps.

variable "username" {
  description = "The username for the IAM user"
  type        = string
  #default     = "lb-user"

}

resource "aws_iam_user" "lb" {
  name = var.username
}

variable "my-map" {
  description = "A map of strings"
  type        = map(string)
  default = {
    Name       = "Alice"
    Department = "HR"
  }
}

output "my-map-output" {
  value = var.my-map
}
