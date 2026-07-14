# terraform fmt is a command used in Terraform to automatically format your Terraform configuration files according to the standard style conventions. It helps maintain consistency and readability in your code by ensuring that indentation, spacing, and other formatting aspects are uniform across all files. This command can be run recursively to format all Terraform files in a directory and its subdirectories.

resource "local_file" "debugging" {
  content  = "Debugging is essential for identifying and fixing issues in your Terraform configurations."
  filename = "${path.module}/debugging.txt"
}

# terraform fmt --recursive
# terraform fmt -check
# terraform fmt -diff
# terraform fmt -write=true
# terraform fmt -list=true
# terraform fmt -list=true -write=false
# terraform fmt -list=true -write=false -diff

# Example of how to use terraform fmt command
# After running terraform fmt, you can use the following command to check if any files need formatting:
# terraform fmt -check