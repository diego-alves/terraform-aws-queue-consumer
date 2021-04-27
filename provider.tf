terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.37"
    }
  }

  required_version = ">= 0.15.1"
}

provider "aws" {
  region  = "us-west-2"
}

