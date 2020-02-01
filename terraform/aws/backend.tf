terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "aws.tfstate"
    region = "us-east-2"
  }
}
