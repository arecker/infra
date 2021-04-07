locals {
  github_cname = "arecker.github.io"
}

terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "bob.tfstate"
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

resource "cloudflare_zone" "bob" {
  zone = "bobrosssearch.com"
}

resource "cloudflare_record" "apex" {
  zone_id = cloudflare_zone.bob.id
  name    = "@"
  value   = local.github_cname
  type    = "CNAME"
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.bob.id
  name    = "www"
  value   = local.github_cname
  type    = "CNAME"
  ttl     = 300
}

output "nameservers" {
  value = cloudflare_zone.bob.name_servers
}
