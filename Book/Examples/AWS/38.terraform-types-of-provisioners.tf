# types of provisioners
# terraform supports several types of provisioners, each with its own use case and functionality. The
# most commonly used provisioners are:
# 1. local-exec: Executes a command on the machine running Terraform. This is useful for running scripts or commands that need to be executed locally, such as generating configuration files or performing local setup tasks.
# 2. remote-exec: Executes a command on the target resource after it has been created. This is useful for configuring the resource, installing software, or performing any other tasks that need to be done on the provisioned resource.
# 3. file: Transfers files from the machine running Terraform to the target resource. This is useful for copying configuration files, scripts, or any other files that need to be present on the provisioned resource.

# Example of using different types of provisioners in a Terraform configuration:
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo 'Provisioning started for ${self.id}'"
  }

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

#Demo
# 1. Remote-Exec will install nginx on the instance.
# 2. Local-Exec will fetch the Public IP of the instance and store it in a file called public_ip.txt.

resource "aws_instance" "web" {
  ami           = "ami-095bd4a11ce8746c0" # Singapore region
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  }
}
