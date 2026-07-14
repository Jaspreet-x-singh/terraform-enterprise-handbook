# Terraform zipmap function is used to create a map from two lists, one containing keys and the other containing values. The function takes two arguments: a list of keys and a list of values, and it returns a map where each key is associated with its corresponding value.

#terraform console

#zipmap(["a", "b", "c"], [1, 2, 3])

#zipmap(["pineapple", "banana", "cherry"], ["yellow", "green", "red"])

resource "aws_iam_user" "example" {
  name  = "iamuser.${count.index + 1}"
  count = 3
}

output "user_map" {
  value = zipmap(
    [for user in aws_iam_user.example : user.name],
    [for user in aws_iam_user.example : user.arn]
  )
}
