terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
      tags = {
          Environment = "test"
          Project     = "test-project-ci/cd"
      }
  }
}