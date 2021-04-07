terraform {
  backend "s3" {
    bucket = "recker-terraform"
    key    = "prod.tfstate"
    region = "us-east-2"
  }
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "cloudflare" {
  email   = "alex@reckerfamily.com"
  api_key = file("${path.module}/../secrets/cloudflare")
}

provider "digitalocean" {
  token = file("${path.module}/../secrets/digitalocean")
}

data "digitalocean_droplet" "prod" {
  name = "prod"
}

resource "digitalocean_domain" "cookbook" {
  name = "thereckerfamilycookbook.com"
}

resource "digitalocean_record" "cookbook_www" {
  domain = digitalocean_domain.cookbook.name
  type   = "A"
  name   = "www"
  value  = data.digitalocean_droplet.prod.ipv4_address
}

resource "digitalocean_record" "cookbook_apex" {
  domain = digitalocean_domain.cookbook.name
  type   = "A"
  name   = "@"
  value  = data.digitalocean_droplet.prod.ipv4_address
}

resource "cloudflare_zone" "cookbook" {
    zone = "thereckerfamilycookbook.com"
}

resource "cloudflare_record" "cookbook_apex" {
  zone_id = cloudflare_zone.cookbook.id
  name    = "@"
  value   = data.digitalocean_droplet.prod.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "cloudflare_record" "cookbook_www" {
  zone_id = cloudflare_zone.cookbook.id
  name    = "www"
  value   = data.digitalocean_droplet.prod.ipv4_address
  type    = "A"
  ttl     = 300
}

resource "digitalocean_firewall" "prod" {
  name = "prod"

  droplet_ids = [data.digitalocean_droplet.prod.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "cookbook_nameservers" {
  value = cloudflare_zone.cookbook.name_servers
}
