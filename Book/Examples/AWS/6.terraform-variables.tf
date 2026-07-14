variable "cidr_block" {
  description = "The CIDR block for the VPC"
  #default     = "10.0.0.0/16"
}

variable "from_port" {
  description = "The starting port for the security group rule"
  #default     = 80
}

variable "to_port" {
  description = "The ending port for the security group rule"
  #default     = 443
}

resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall-allow-tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  #vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "terraform-firewall-allow-tls"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_port_80" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block
  from_port         = var.from_port
  ip_protocol       = "tcp"
  to_port           = var.to_port
}

resource "aws_vpc_security_group_egress_rule" "allow_tls_port_443" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block
  from_port         = var.from_port
  ip_protocol       = "tcp"
  to_port           = var.to_port
}
