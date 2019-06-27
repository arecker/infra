terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
