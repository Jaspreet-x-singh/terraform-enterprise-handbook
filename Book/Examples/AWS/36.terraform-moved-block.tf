# terraform moved block is a feature that allows you to move a block of code from one location to another within a Terraform configuration. This can be useful for reorganizing your code, refactoring, or moving resources between modules. The moved block retains its original functionality and can be used in the new location without any changes.
# Example of using a moved block in a Terraform configuration:

# Old location of the resource block
resource "aws_security_group" "db-firewall" {
  name        = "db-firewall"
  description = "Security group for database instances"
}

# New location of the resource block using a moved block
resource "aws_security_group" "payments-db-firewall" {
  name        = "payments-db-firewall"
  description = "Security group for payments database instances"
}

moved {
  from = aws_security_group.db-firewall
  to   = aws_security_group.payments-db-firewall
}
