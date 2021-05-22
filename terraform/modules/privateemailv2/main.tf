variable "cloudflare_zone_id" {
  type = string
}

variable "cloudflare_zone_name" {
  type = string
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_record" "mx" {
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_zone_name
  type    = "TXT"
  ttl     = "3600"
  proxied = false
  value   = "v=spf1 include:spf.privateemail.com ~all"
}
