+++
title = 'Terraform Digitalocean Droplet with user-data'
image = '/images/post/terraform.png'
author = 'Naim'
date = 2021-03-09
description = 'A quick terraform guide for setting up droplet with user-data in digitalocean.'
categories = ["terraform"]
type = 'post'
+++

A quick terraform guide for setting up droplet with user-data in digitalocean.

User-data is arbitrary data that a user can supply to a Droplet during its creation time. User-data can be consumed by CloudInit, typically during the first boot of a cloud server, to perform tasks or run scripts as the root user–this can be extremely useful when provisioning a server.


## Quickstart

- Clone this repo

  ```bash
  git clone https://github.com/tankibaj/Digitalocean-Terraform-Droplet.git
  ```

- Generate your digitalocean API token: https://cloud.digitalocean.com/account/api/tokens

  ```bash
  export TF_VAR_do_token="type_your_token_here"
  ```

- Prepare your working directory for other commands

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

- Destroy previously created infrastructure

  ```bash
  terraform destroy
  ```

- Unset token

  ```bash
  unset TF_VAR_do_token
  ```