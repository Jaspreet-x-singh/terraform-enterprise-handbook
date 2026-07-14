# terraform provisioners are used to execute scripts or commands on the target infrastructure after it has been created. They can be used for configuration management, software installation, or any other tasks that need to be performed on the provisioned resources.
# # # Example: terraform provisioners
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }
}
