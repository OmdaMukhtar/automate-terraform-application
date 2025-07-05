terraform {
  # Production development
  # backend "s3" {
  #   key = "web-server"
  #   bucket = "terraform-backend-terraformbackends3bucket-9r8ui0vz9fhl"
  #   region = "us-east-1"
  #   dynamodb_table = "terraform-backend-TerraformBackendDynamoDBTable-1R1MC4XTVNJGP"
  # }

  # Local development
  backend "local" {
    path = "terraform.tfstate"
  }
}
