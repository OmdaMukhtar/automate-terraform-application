terraform {
  # Production development
  backend "s3" {
    key = "web-server"
    bucket = "terraform-locks-oop123"
    dynamodb_table = "terraform-lock-oop"
    region = "ap-northeast-1"
  }

  # Local development
#   backend "local" {
#     path = "terraform.tfstate"
#   }
}
