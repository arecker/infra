terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "vault.tfstate"
    region = "us-east-2"
  }
}
