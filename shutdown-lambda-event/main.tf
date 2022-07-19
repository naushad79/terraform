terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket  = "test-state-123"
    key     = "testing.tfstate"
    region  = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

