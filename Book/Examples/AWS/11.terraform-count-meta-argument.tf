# terraform count meta-argument is a feature in Terraform that allows you to create multiple instances of a resource or module based on a specified count value. By using the count argument, you can define how many instances of a resource should be created, and Terraform will automatically manage the creation and destruction of those instances based on the count value. This is useful for scaling resources up or down dynamically.

resource "aws_instance" "myec2-1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = 3
}

resource "aws_iam_user" "myuser" {
  name  = "payments-user"
  count = 3
}

# Example of how to use count meta-argument
# After running terraform apply, you can use the following command to display the output values:
# terraform output
