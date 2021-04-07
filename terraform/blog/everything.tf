locals {
  netlify_cname = "arecker-blog.netlify.com"
  github_cname = "arecker.github.io"
}

terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "blog.tfstate"
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

resource "cloudflare_zone" "blog" {
  zone = "alexrecker.com"
}

resource "cloudflare_record" "blog_apex" {
  zone_id = cloudflare_zone.blog.id
  name    = "@"
  value   = local.netlify_cname
  type    = "CNAME"
}

resource "cloudflare_record" "blog_www" {
  zone_id = cloudflare_zone.blog.id
  name    = "www"
  value   = local.netlify_cname
  type    = "CNAME"
  ttl     = 300
}


resource "cloudflare_record" "demo" {
  zone_id = cloudflare_zone.blog.id
  name    = "demo"
  value   = local.github_cname
  type    = "CNAME"
  ttl     = 300
}

resource "cloudflare_record" "archive" {
  zone_id = cloudflare_zone.blog.id
  name    = "archive"
  value   = local.github_cname
  type    = "CNAME"
  ttl     = 300
}

output "blog_nameservers" {
  value = cloudflare_zone.blog.name_servers
}
