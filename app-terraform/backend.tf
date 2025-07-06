terraform {
  # Production development
  backend "s3" {
    key = "web-server"
    bucket = "terraform-locks-oop"
    dynamodb_table = "terraform-locks-oop123"
  }

  # Local development
#   backend "local" {
#     path = "terraform.tfstate"
#   }
}
