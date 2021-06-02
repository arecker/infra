terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "tranquility.tfstate"
    region = "us-east-2"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

provider "cloudflare" {
  email   = "alex@reckerfamily.com"
  api_key = file("${path.module}/../secrets/cloudflare")
}

resource "cloudflare_zone" "zone" {
  zone = "tranquilitydesignsmn.com"
}

output "nameservers" {
  value = cloudflare_zone.zone.name_servers
}
