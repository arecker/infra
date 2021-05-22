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

resource "cloudflare_record" "txt" {
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_zone_name
  type    = "TXT"
  ttl     = "3600"
  proxied = false
  value   = "v=spf1 include:spf.privateemail.com ~all"
}

resource "cloudflare_record" "mx1" {
  zone_id  = var.cloudflare_zone_id
  name     = var.cloudflare_zone_name
  type     = "MX"
  ttl      = "3600"
  proxied  = false
  priority = "10"
  value    = "mx1.privateemail.com"

}

resource "cloudflare_record" "mx2" {
  zone_id  = var.cloudflare_zone_id
  name     = var.cloudflare_zone_name
  type     = "MX"
  ttl      = "3600"
  proxied  = false
  priority = "10"
  value    = "mx2.privateemail.com"
}

resource "cloudflare_record" "autoconfig" {
  zone_id = var.cloudflare_zone_id
  name    = format("%s.%s", "autoconfig", var.cloudflare_zone_name)
  type    = "CNAME"
  proxied = false
  ttl     = "60"
  value   = "privateemail.com"
}

resource "cloudflare_record" "autodiscover" {
  zone_id = var.cloudflare_zone_id
  name    = format("%s.%s", "autodiscover", var.cloudflare_zone_name)
  type    = "CNAME"
  proxied = false
  ttl     = "60"
  value   = "privateemail.com"
}


resource "cloudflare_record" "srv" {
  zone_id = var.cloudflare_zone_id
  name    = format("%s.%s", "autodiscover", var.cloudflare_zone_name)
  type    = "SRV"

  data = {
    service  = "_autodiscover"
    proto    = "_tcp"
    name     = var.cloudflare_zone_name
    priority = 0
    weight   = 0
    port     = 443
    target   = var.cloudflare_zone_name
  }
}

resource "cloudflare_record" "mail" {
  zone_id = var.cloudflare_zone_id
  name    = format("%s.%s", "mail", var.cloudflare_zone_name)
  type    = "CNAME"
  proxied = false
  ttl     = "60"
  value   = "privateemail.com"
}
