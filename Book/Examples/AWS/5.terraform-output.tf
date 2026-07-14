resource "aws_eip" "lb" {
}

output "elastic_ip_address" {
  value = aws_eip.lb[*]
}