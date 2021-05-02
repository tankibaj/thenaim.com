# Host a Static Website with S3 and Cloudflare

Cloudflare is a popular service that offers a Content Delivery Network (CDN), Domain Name System (DNS), and protection against Distributed Denial of Service (DDoS) attacks. The Terraform Cloudflare provider allows you to deploy and manage your content distribution services with the same workflow you use to manage infrastructure. Using Terraform, you can provision DNS records and distribution rules for your web applications hosted in AWS and other cloud services, as well as the underlying infrastructure hosting your services.



We will deploy a static website using the AWS and Cloudflare providers. The site will use AWS to provision an S3 bucket for object storage and Cloudflare for DNS, [SSL](https://www.cloudflare.com/ssl/) and [CDN](https://www.cloudflare.com/cdn/). Then, we will add Cloudflare [page rules](https://support.cloudflare.com/hc/en-us/articles/218411427-Understanding-and-Configuring-Cloudflare-Page-Rules-Page-Rules-Tutorial-) to always redirect HTTP requests to HTTPS and to temporarily redirect users when they visit a specific page.



## Quick Start

- Prepare your working directory for other commands

  ```bash
  cp terraform.tfvars.example terraform.tfvars
  ```

  ```bash
  terraform init
  ```

- Show changes required by the current configuration

  ```bash
  terraform plan
  ```

- Create infrastructure

  ```bash
  terraform apply
  ```