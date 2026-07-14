# # Terraform Graph refers to the command `terraform graph` which is used to generate a visual representation of the Terraform resources and their dependencies in a Terraform configuration. This command outputs a DOT format graph that can be rendered using Graphviz or other visualization tools.

resource "aws_eip" "lb_eip" {
  domain = "vpc"
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for load balancer"
}

resource "aws_vpc_security_group_ingress_rule" "lb_sg_rule" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "${aws_eip.lb_eip.public_ip}/32"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_instance" "web_server" {
  ami             = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.lb_sg.name]

  tags = {
    Name = "WebServer"
  }
}


## Example of how to use terraform graph command
# After running terraform apply, you can use the following command to generate a graph of the resources
# terraform graph | dot -Tpng > graph.png