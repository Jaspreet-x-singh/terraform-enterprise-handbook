# terraform for_each is a meta-argument that allows you to create multiple instances of a resource or module based on a specified map or set of values. It is similar to the count meta-argument, but instead of using a numeric value to determine the number of instances, for_each uses a collection of values (map or set) to create instances.
# terrraform for_each is particularly useful when you want to create resources or modules based on a dynamic set of values, such as a list of names, IDs, or other attributes. It allows you to iterate over the collection and create a separate instance for each value in the collection.
# terrraform for_each can be used with both resources and modules, and it is often used in conjunction with other meta-arguments like depends_on and lifecycle to manage the behavior of the created instances.

# Example of using for_each with a resource:
variable "instance_names" {
  type    = set(string)
  default = ["instance1", "instance2", "instance3"]
}

resource "aws_instance" "ec2_instance" {
  for_each = var.instance_names

  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"
  tags = {
    Name        = each.value # The each.value expression is used to access the current value of the instance_names set during the iteration. This allows each created EC2 instance to have a unique Name tag based on the values in the instance_names set.
    Environment = "Testing"
  }
}
