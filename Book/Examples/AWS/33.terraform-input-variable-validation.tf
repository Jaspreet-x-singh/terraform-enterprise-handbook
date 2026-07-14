# terraform input variable validation is a feature that allows you to define constraints on the values of input variables in Terraform configurations. This helps ensure that the values provided for variables meet certain criteria, such as being within a specific range, matching a pattern, or being one of a set of allowed values. Input variable validation can help prevent misconfigurations and improve the reliability of your Terraform deployments.
# Example of using input variable validation in a variable definition:
variable "instance_count" {
  type        = number
  description = "The number of instances to create"
  default     = 1

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10 # The condition specifies that the instance_count variable must be greater than 0 and less than or equal to 10. This ensures that the number of instances created is within a valid range.
    error_message = "The instance_count must be between 1 and 10."
  }
}
# Example of using input variable validation with a string variable:
variable "environment" {
  type        = string
  description = "The environment for the deployment"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment) # The condition checks if the value of the environment variable is one of the allowed values: "dev", "staging", or "prod". This ensures that only valid environment names are used.
    error_message = "The environment must be one of 'dev', 'staging', or 'prod'."
  }
}
# Example of using input variable validation with a list variable:
variable "instance_types" {
  type        = list(string)
  description = "The list of instance types to use"
  default     = ["t2.micro", "t2.small"]

  validation {
    condition     = alltrue([for t in var.instance_types : contains(["t2.micro", "t2.small", "t2.medium"], t)]) # The condition checks if all values in the instance_types list are one of the allowed instance types: "t2.micro", "t2.small", or "t2.medium". This ensures that only valid instance types are used.
    error_message = "All instance types must be one of 't2.micro', 't2.small', or 't2.medium'."
  }
}
# Example of using input variable validation with a map variable:
variable "tags" {
  type        = map(string)
  description = "The tags to apply to the resources"
  default = {
    "Environment" = "dev"
    "Owner"       = "team-a"
  }

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) > 0]) # The condition checks if all keys and values in the tags map are non-empty strings. This ensures that valid tags are provided for the resources.
    error_message = "All tag keys and values must be non-empty strings."
  }
}
# Example of using input variable validation with a boolean variable:
variable "enable_feature" {
  type        = bool
  description = "Whether to enable the feature"
  default     = false

  validation {
    condition     = var.enable_feature == true || var.enable_feature == false # The condition checks if the value of the enable_feature variable is either true or false. This ensures that only valid boolean values are used.
    error_message = "The enable_feature variable must be a boolean value (true or false)."
  }
}
# Example of using input variable validation with a tuple variable:
variable "instance_config" {
  type        = tuple([string, number, bool])
  description = "The configuration for the instance"
  default     = ["t2.micro", 1, true]

  validation {
    condition     = length(var.instance_config) == 3 && var.instance_config[1] > 0 # The condition checks if the instance_config tuple has exactly three elements and that the second element (number of instances) is greater than 0. This ensures that the configuration is valid.
    error_message = "The instance_config must be a tuple with three elements: [instance_type, instance_count, enable_feature]."
  }
}
#Example of using input variable validation with an object variable:
variable "instance_details" {
  type = object({
    instance_type  = string
    instance_count = number
    enable_feature = bool
  })
  description = "The details of the instance"
  default = {
    instance_type  = "t2.micro"
    instance_count = 1
    enable_feature = true
  }

  validation {
    condition     = var.instance_details.instance_count > 0 && contains(["t2.micro", "t2.small", "t2.medium"], var.instance_details.instance_type) # The condition checks if the instance_count is greater than 0 and if the instance_type is one of the allowed values. This ensures that the instance details are valid.
    error_message = "The instance_details must have a valid instance_type and a positive instance_count."
  }
}
# Example of using input variable validation with a set variable:
variable "allowed_ips" {
  type        = set(string)
  description = "The set of allowed IP addresses"
  default     = ["10.0.0.0/8"]

  validation {
    condition     = alltrue([for ip in var.allowed_ips : cidrnetmask(ip) != ""]) # The condition checks if all IP addresses in the set are valid CIDR notation.
    error_message = "All IP addresses in allowed_ips must be valid CIDR notation."
  }
}
# Example of using input variable validation with a number variable:
variable "max_connections" {
  type        = number
  description = "The maximum number of connections"
  default     = 100

  validation {
    condition     = var.max_connections > 0 && var.max_connections <= 1000 # The condition checks if the max_connections variable is greater than 0 and less than or equal to 1000. This ensures that the number of connections is within a valid range.
    error_message = "The max_connections must be between 1 and 1000."
  }
}
# Example of using input variable validation with a string variable and regex pattern:
variable "username" {
  type        = string
  description = "The username for the application"
  default     = "user123"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]+$", var.username)) # The condition checks if the username variable matches the specified regex pattern, which allows only alphanumeric characters and underscores.
    error_message = "The username must contain only alphanumeric characters and underscores."
  }
}
# Example of using input variable validation with a list variable and length constraint:
variable "server_names" {
  type        = list(string)
  description = "The list of server names"
  default     = ["server1", "server2"]

  validation {
    condition     = length(var.server_names) > 0 && length(var.server_names) <= 5 # The condition checks if the server_names list has at least one element and no more than five elements. This ensures that the number of server names is within a valid range.
    error_message = "The server_names list must contain between 1 and 5 server names."
  }
}
