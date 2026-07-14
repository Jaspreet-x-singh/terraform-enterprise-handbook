# terraform data type object is a complex data type that allows you to define a structured collection of attributes with different types. It is defined using a schema, which specifies the names and types of the attributes that the object can contain. Objects are useful for representing more complex data structures in Terraform configurations, such as configurations for resources or modules.
# Example of using an object data type in a variable definition:
variable "my_object" {
  type = object({
    name       = string
    age        = number
    is_student = bool
  })
  default = {
    name       = "John"
    age        = 30
    is_student = true
  }
}