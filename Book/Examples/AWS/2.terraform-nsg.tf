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
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_port_443" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
