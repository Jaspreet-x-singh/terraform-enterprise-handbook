# terraform meta-arguments are special arguments that can be used in Terraform configurations to control the behavior of resources and modules. These arguments are not specific to any particular resource or provider, but rather apply to all resources and modules in a configuration. Some common meta-arguments include:

# - count: This argument allows you to create multiple instances of a resource or module based on a specified count value. For example, you can use count to create multiple EC2 instances or S3 buckets.
# - for_each: This argument allows you to create multiple instances of a resource or module based on a specified map or set of values. For example, you can use for_each to create multiple IAM users or security groups based on a list of names.
# - depends_on: This argument allows you to specify dependencies between resources or modules. By default, Terraform automatically determines the dependencies between resources based on their references, but you can use depends_on to explicitly define dependencies when necessary.
# - provider: This argument allows you to specify which provider to use for a resource or module. This can be useful when you have multiple providers configured in your Terraform configuration and want to use a specific provider for a particular resource or module.
# - lifecycle: This argument allows you to customize the behavior of a resource or module during its lifecycle. For example, you can use lifecycle to prevent a resource from being destroyed or to create a resource before another resource is created.

resource "aws_instance" "ec2_instance" {
  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"
  tags = {
    Name        = "MyFirstEC2Instance"
    Environment = "Testing"
  }
  lifecycle {
    ignore_changes = [tags]
    #create_before_destroy = true
    #prevent_destroy       = true
  }
}
