terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "wedding.tfstate"
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
  zone = "alexandmarissa.com"
}

module "email" {
  source               = "../modules/privateemailv2"
  cloudflare_zone_id   = cloudflare_zone.zone.id
  cloudflare_zone_name = cloudflare_zone.zone.zone
}

resource "cloudflare_record" "www" {
  zone_id = cloudflare_zone.zone.id
  name    = "www"
  type    = "CNAME"
  proxied = true
  ttl     = "1"
  value   = "arecker.github.io"
}

resource "cloudflare_record" "apex" {
  zone_id = cloudflare_zone.zone.id
  name    = cloudflare_zone.zone.zone
  type    = "CNAME"
  proxied = true
  ttl     = "1"
  value   = format("www.%s", cloudflare_zone.zone.zone)
}
