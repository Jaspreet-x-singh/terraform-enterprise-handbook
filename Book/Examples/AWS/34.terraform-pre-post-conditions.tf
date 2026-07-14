# terraform pre-conditions and post-conditions are features that allow you to define conditions that must be met before or after a resource is created, updated, or destroyed. These conditions can be used to enforce certain rules or constraints on the resources in your Terraform configuration.

# Example of using pre-conditions in a resource definition:
variable "instance_type" {
  type        = string
  description = "The type of instance to create"
  default     = "t2.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  # Pre-condition: Ensure that the instance type is valid before creating the resource
  lifecycle {
    precondition {
      condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
      error_message = "The instance_type must be one of 't2.micro', 't2.small', or 't2.medium'."
    }
  }

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_instance_type" "example" {
  instance_type = var.instance_type
  ami           = "ami-0c55b159cbfafe1f0"

  # Pre-condition: Ensure that the instance type is valid before creating the resource
  lifecycle {
    precondition {
      condition     = data.aws_instance_type.example.free_tier_eligible == true
      error_message = "The instance_type must be eligible for the free tier."
    }
    postcondition {
      condition     = data.aws_instance_type.example.public_ip == true
      error_message = "The instance_type must have a public IP address."
    }
  }
}

# Example of using post-conditions in a resource definition:
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"

  # Post-condition: Ensure that the bucket name is unique after creating the resource
  lifecycle {
    postcondition {
      condition     = length(aws_s3_bucket.example.bucket) > 0
      error_message = "The S3 bucket name must be unique and not empty."
    }
  }

  tags = {
    Name = "MyS3Bucket"
  }
}
