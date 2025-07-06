terraform {
  # Production development
  backend "s3" {
    key = "web-server"
    bucket = "terraform-locks-oop123"
    dynamodb_table = "terraform-lock-oop"
  }

  # Local development
#   backend "local" {
#     path = "terraform.tfstate"
#   }
}
