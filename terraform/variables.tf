variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region to put the bucket into"
}

variable "domain" {
  type        = string
  description = "The domain name to use for the static site"
}

variable "cloudflare_email" {
  type        = string
  description = "The email associated with the Cloudflare account"
}

variable "cloudflare_api_token" {
  type        = string
  description = "The Cloudflare API Token"
}
