provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}

provider "google" {
  project = "infra-252416"
  region  = "us-central-1"
}
