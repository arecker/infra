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

resource "aws_route53_record" "alexandmarissa_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "_8975bb72445a03cb2eac785db02df900.www.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_abbebe22d46fd26c148e84464fd92d94.acm-validations.aws."
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_srv" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "_autodiscover._tcp.alexandmarissa.com."
  type    = "SRV"
  ttl     = "60"
  records = [
    "0 0 443 privateemail.com"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_autoconfig" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "autoconfig.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_autodiscover" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "autodiscover.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_mail" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "mail.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "privateemail.com"
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_a" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com."
  type    = "A"
  
  alias {
    name		   = "d3btgoohyfvuql.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alexandmarissa_dot_com_www" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "www.alexandmarissa.com."
  type    = "A"
  
  alias {
    name		   = "du1wn5e8ke9q8.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

##################
# astuaryart.com #
##################

resource "aws_route53_record" "astuaryart_dot_com_ns" {
  zone_id = "${aws_route53_zone.astuaryart_dot_com.zone_id}"
  name    = "astuaryart.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-2003.awsdns-58.co.uk.",
    "ns-732.awsdns-27.net.",
    "ns-1315.awsdns-36.org.",
    "ns-509.awsdns-63.com."
  ]
}

resource "aws_route53_record" "astuaryart_dot_com_soa" {
  zone_id = "${aws_route53_zone.astuaryart_dot_com.zone_id}"
  name    = "astuaryart.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-2003.awsdns-58.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "astuaryart_dot_com_a" {
  zone_id = "${aws_route53_zone.astuaryart_dot_com.zone_id}"
  name    = "astuaryart.com."
  type    = "A"
  ttl     = "900"
  records = [
    "198.185.159.145",
    "198.185.159.144",
    "198.49.23.144",
    "198.49.23.145"
  ]
}

resource "aws_route53_record" "astuaryart_dot_com_cname0" {
  zone_id = "${aws_route53_zone.astuaryart_dot_com.zone_id}"
  name    = "mhchbrbazfjmhxkzrn8c.astuaryart.com."
  type    = "CNAME"
  ttl     = "900"
  records = [
    "verify.squarespace.com"
  ]
}

resource "aws_route53_record" "astuaryart_dot_com_www" {
  zone_id = "${aws_route53_zone.astuaryart_dot_com.zone_id}"
  name    = "www.astuaryart.com."
  type    = "CNAME"
  ttl     = "900"
  records = [
    "ext-cust.squarespace.com"
  ]
}

##################
# alexrecker.com #
##################

resource "aws_route53_record" "alexrecker_dot_com_ns" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "alexrecker.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-459.awsdns-57.com.",
    "ns-955.awsdns-55.net.",
    "ns-2015.awsdns-59.co.uk.",
    "ns-1154.awsdns-16.org."
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_soa" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "alexrecker.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-459.awsdns-57.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_a" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "alexrecker.com."
  type    = "A"
  
  alias {
    name		   = "d1bfi2q3w1ea6p.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alexrecker_dot_com_www" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "www.alexrecker.com."
  type    = "A"
  
  alias {
    name		   = "d379b797q706o3.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alexrecker_dot_com_demo" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "demo.alexrecker.com."
  type    = "A"
  
  alias {
    name		   = "do8xdzpkvvnsu.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alexrecker_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "_1ec36ef1d8d85f92e9b8e6fba66407d7.alexrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_64b801e8f440524c6bfb33589ce46672.acm-validations.aws."
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "_6d3bd331262ba8fa1942cb67364a1c0a.www.alexrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_d6c6054ce0d03e793a4f0b1d59a25eda.acm-validations.aws."
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_ssl3" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "_51f80347a1363e6bb9cbf7747e20c100.demo.alexrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_e27ab6998cc5d6cfbf6cdd97f8b1f03b.acm-validations.aws."
  ]
}
