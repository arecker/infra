terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "do.tfstate"
    region = "us-east-2"
  }
}
