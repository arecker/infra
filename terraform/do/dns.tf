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
