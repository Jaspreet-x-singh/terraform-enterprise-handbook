# terraform check is a command that validates the configuration files in a Terraform project. It checks for syntax errors, missing variables, and other issues that could prevent the successful execution of Terraform commands.

# # Example: terraform check

check "website_check" {
  data "http" "terraform.io" {
    url = "https://terraform.io"
  }

  assert {
    condition     = data.http.terraform.io.status_code == 200
    error_message = "Website is not reachable or returned a non-200 status code."
  }
}

check "api_check" {
  data "http" "api.example.com" {
    url = "https://api.example.com/health"
  }

  assert {
    condition     = data.http.api.example.com.status_code == 200
    error_message = "API is not reachable or returned a non-200 status code."
  }
}
