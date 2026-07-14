resource "local_file" "debugging" {
  content  = "Debugging is essential for identifying and fixing issues in your Terraform configurations."
  filename = "${path.module}/debugging.txt"
}

# set TF_LOG=INFO
# set TF_LOG_PATH=terraform.log
# set TF_LOG=DEBUG
# set TF_LOG_PATH=terraform_debug.log
# set TF_LOG=TRACE
# set TF_LOG_PATH=terraform_trace.log

# Example of how to use debugging in Terraform
# After running terraform apply, you can use the following command to check the logs:
# terraform apply