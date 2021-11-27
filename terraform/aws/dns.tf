locals {
  github_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

############################
# tranquilitydesignsmn.com #
############################

resource "aws_route53_zone" "tranquilitydesignsmn_dot_com" {
  name = "tranquilitydesignsmn.com."
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_ns" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "tranquilitydesignsmn.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-1990.awsdns-56.co.uk.",
    "ns-39.awsdns-04.com.",
    "ns-769.awsdns-32.net.",
    "ns-1227.awsdns-25.org."
  ]
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_soa" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "tranquilitydesignsmn.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-1990.awsdns-56.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_apex" {
  zone_id         = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name            = "tranquilitydesignsmn.com."
  type            = "A"
  ttl             = "300"
  records         = local.github_ips
  allow_overwrite = true
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_cname" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "www.tranquilitydesignsmn.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "arecker.github.io."
  ]
  allow_overwrite = true
}

module "tranquilitydesignsmn_dot_com_privateemail" {
  source    = "../modules/privateemail"
  zone_name = "tranquilitydesignsmn.com."
}
