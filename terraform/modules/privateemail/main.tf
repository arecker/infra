data "aws_route53_zone" "zone" {
  name = "${var.zone_name}"
}

resource "aws_route53_record" "txt" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.zone_name}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:spf.privateemail.com ~all"
  ]
}

resource "aws_route53_record" "mx" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.zone_name}"
  type    = "MX"
  ttl     = "3600"
  records = [
    "10 mx1.privateemail.com",
    "10 mx2.privateemail.com"
  ]
}

resource "aws_route53_record" "autoconfig" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "autoconfig.${var.zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}

resource "aws_route53_record" "autodiscover" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "autodiscover.${var.zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}

resource "aws_route53_record" "srv" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "_autodiscover._tcp.${var.zone_name}"
  type    = "SRV"
  ttl     = "60"
  records = [
    "0 0 443 privateemail.com"
  ]
}

resource "aws_route53_record" "mail" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "mail.${var.zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}
