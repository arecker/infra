locals {
  token_path = "${path.root}/secrets/token"
}

provider "vault" {
  address = "http://vault.local"
  token	  = chomp(file(local.token_path))
}

provider "aws" {
  region = "us-east-2"
}
