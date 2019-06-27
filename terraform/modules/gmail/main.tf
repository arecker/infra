data "aws_route53_zone" "zone" {
  name = "${var.zone_name}"
}

resource "aws_route53_record" "mx" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.zone_name}"
  type    = "MX"
  ttl     = "3600"
  records = [
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "1 ASPMX.L.GOOGLE.COM."
  ]
}
