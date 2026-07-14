# # splat expression allows us to get a list of all the attributes of a resource. It is used to access multiple values from a resource or module.
resource "aws_instance" "example" {
  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}
# Example: Accessing the attributes of all EC2 instances
output "instance_ids" {
  value = aws_instance.example[*].id
}

resource "aws_iam_user" "example" {
  count = 3
  name  = "iam_user_${count.index + 1}"
}
output "iam_user_names" {
  value = aws_iam_user.example[*].name
}

# Example of how to use splat expression
# After running terraform apply, you can use the following command to display the output values:
# terraform output instance_ids
