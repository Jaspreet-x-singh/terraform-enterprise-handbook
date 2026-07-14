# terraform count and index are features that allow you to create multiple instances of a resource or module based on a specified count. The count parameter is used to define the number of instances to create, while the index is used to access the current instance's index within the count. This enables you to create resources dynamically and manage them efficiently.

resource "aws_iam_user" "myuser" {
  name  = "payments-user"
  count = 3
  tags = {
    "Name" = "payments-user-${count.index}"
  }
}

variable "usernames" {
  description = "A list of usernames"
  type        = list(string)
  default     = ["Alice", "Bob", "Michael"]
}

resource "aws_iam_user" "myuser" {
  name  = var.usernames[count.index]
  count = length(var.usernames)
  tags = {
    "Name" = var.usernames[count.index]
  }
}

# Example of how to use count and index
# After running terraform apply, you can use the following command to display the output values:
# terraform output