######################
# alexandmarissa.com #
######################

resource "aws_route53_record" "alexandmarissa_dot_com_ns" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-1416.awsdns-49.org.",
    "ns-1770.awsdns-29.co.uk.",
    "ns-947.awsdns-54.net.",
    "ns-470.awsdns-58.com."
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_soa" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-1416.awsdns-49.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_txt" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com"
  type    = "TXT"
  ttl     = "3600"
  records = [
    "v=spf1 include:spf.privateemail.com ~all"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_mx" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com"
  type    = "MX"
  ttl     = "3600"
  records = [
    "10 mx1.privateemail.com",
    "10 mx2.privateemail.com"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "_9b6c62a54140cc353201d576344dc5e9.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_63370ee7158160fd2dad2102d377c786.acm-validations.aws."
  ]
}
