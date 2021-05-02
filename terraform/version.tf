terraform {
  required_version = "~> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}