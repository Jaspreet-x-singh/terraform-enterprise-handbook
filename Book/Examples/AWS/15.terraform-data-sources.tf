# terraform data sources are used to retrieve information about existing resources in your infrastructure. They allow you to reference and use data from resources that are not managed by your Terraform configuration, enabling you to integrate with external systems and services. Data sources can be used to fetch details such as AMI IDs, VPCs, subnets, security groups, and more.

data "aws_security_group" "MyWebServer-sg" {
  name = "MyWebServer-sg"
}

output "MyWebServer-sg-id" {
  value = data.aws_security_group.MyWebServer-sg.id
}
output "MyWebServer-sg-name" {
  value = data.aws_security_group.MyWebServer-sg.name
}
output "MyWebServer-sg-description" {
  value = data.aws_security_group.MyWebServer-sg.description
}
output "MyWebServer-sg-vpc-id" {
  value = data.aws_security_group.MyWebServer-sg.vpc_id
}

# Example of how to use data sources
# After running terraform apply, you can use the following command to display the output values:
# terraform output