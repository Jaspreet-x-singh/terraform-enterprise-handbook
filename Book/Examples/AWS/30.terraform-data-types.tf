# terraform data types refers to the different types of data that can be used in Terraform configurations. These data types include:

# Data Types:
# 1. String: A sequence of characters enclosed in double quotes. Example: "Hello, World!"
# 2. Number: A numeric value, which can be an integer or a floating-point number. Example: 42 or 3.14
# 3. Boolean: A true or false value. Example: true or false
# 4. List: An ordered collection of values, enclosed in square brackets. Example: ["apple", "banana", "cherry"]
# 5. Map: An unordered collection of key-value pairs, enclosed in curly braces. Example: { "key1" = "value1", "key2" = "value2" }
# 6. Set: An unordered collection of unique values, enclosed in square brackets. Example: ["apple", "banana", "cherry"]
# 7. Tuple: An ordered collection of values of different types, enclosed in parentheses. Example: ("apple", 42, true)
# 8. Object: A complex data type that can contain multiple attributes of different types, defined using a schema. Example: { "name" = "John", "age" = 30, "is_student" = false }

# Terraform examples of data types:

variable "my_string" {
  type    = string
  default = "Hello, World!"
}

variable "my_number" {
  type    = number
  default = 42
}

variable "my_boolean" {
  type    = boolean
  default = true
}

variable "my_list" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

variable "my_map" {
  type = map(string)
  default = {
    "key1" = "value1"
    "key2" = "value2"
  }
}

variable "my_set" {
  type    = set(string)
  default = ["apple", "banana", "cherry"]
}

variable "my_tuple" {
  type    = tuple([string, number, boolean])
  default = ["apple", 42, true]
}

variable "my_object" {
  type = object({
    name       = string
    age        = number
    is_student = boolean
  })
  default = {
    name       = "John"
    age        = 30
    is_student = false
  }
}
