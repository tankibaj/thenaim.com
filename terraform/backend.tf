terraform {
  backend "remote" {
    organization = "thenaim"

    workspaces {
      name = "thenaim-com"
    }
  }
}