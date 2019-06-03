######################
# alexandmarissa.com #
######################

resource "aws_route53_zone" "alexandmarissa_dot_com" {
  name = "alexandmarissa.com."
}

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

module "alexandmarissa_dot_com_privateemail" {
  source = "./modules/privateemail"
  zone_name = "alexandmarissa.com."
}

##################
# astuaryart.com #
##################

resource "aws_route53_zone" "astuaryart_dot_com" {
  name = "astuaryart.com."
}

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

resource "aws_route53_zone" "alexrecker_dot_com" {
  name = "alexrecker.com."
}

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

#####################
# bobrosssearch.com #
#####################

resource "aws_route53_zone" "bobrosssearch_dot_com" {
  name = "bobrosssearch.com."
}

resource "aws_route53_record" "bobrosssearch_dot_com_ns" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "bobrosssearch.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-1700.awsdns-20.co.uk.",
    "ns-601.awsdns-11.net.",
    "ns-405.awsdns-50.com.",
    "ns-1249.awsdns-28.org."
  ]
}

resource "aws_route53_record" "bobrosssearch_dot_com_soa" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "bobrosssearch.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-405.awsdns-50.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

####################
# reckerfamily.com #
####################

resource "aws_route53_zone" "reckerfamily_dot_com" {
  name = "reckerfamily.com."
}

resource "aws_route53_record" "reckerfamily_dot_com_ns" {
  zone_id = "${aws_route53_zone.reckerfamily_dot_com.zone_id}"
  name    = "reckerfamily.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-215.awsdns-26.com.",
    "ns-760.awsdns-31.net.",
    "ns-1593.awsdns-07.co.uk.",
    "ns-1173.awsdns-18.org."
  ]
}

resource "aws_route53_record" "reckerfamily_dot_com_soa" {
  zone_id = "${aws_route53_zone.reckerfamily_dot_com.zone_id}"
  name    = "reckerfamily.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-215.awsdns-26.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

module "reckerfamily_dot_com_gmail" {
  source = "./modules/gmail"
  zone_name = "reckerfamily.com."
}

#######################
# fromdirktolight.com #
#######################

resource "aws_route53_zone" "fromdirktolight_dot_com" {
  name = "fromdirktolight.com."
}

resource "aws_route53_record" "fromdirktolight_dot_com_ns" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "fromdirktolight.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-1231.awsdns-25.org.",
    "ns-62.awsdns-07.com.",
    "ns-1004.awsdns-61.net.",
    "ns-1742.awsdns-25.co.uk."
  ]
}

resource "aws_route53_record" "fromdirktolight_dot_com_soa" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "fromdirktolight.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-1004.awsdns-61.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
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

module "tranquilitydesignsmn_dot_com_privateemail" {
  source = "./modules/privateemail"
  zone_name = "tranquilitydesignsmn.com."
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_api" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "api.tranquilitydesignsmn.com."
  type    = "A"
  
  alias {
    name		   = "dyjobn5aj21lk.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

###################
# sarahrecker.com #
###################

resource "aws_route53_zone" "sarahrecker_dot_com" {
  name = "sarahrecker.com."
}

resource "aws_route53_record" "sarahrecker_dot_com_ns" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "sarahrecker.com"
  type    = "NS"
  ttl     = "172800"
  records = [
    "ns-632.awsdns-15.net.",
    "ns-1949.awsdns-51.co.uk.",
    "ns-209.awsdns-26.com.",
    "ns-1153.awsdns-16.org."
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_soa" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "sarahrecker.com"
  type    = "SOA"
  ttl     = "900"
  records = [
    "ns-632.awsdns-15.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_api" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "api.sarahrecker.com"
  type    = "A"
  
  alias {
    name		   = "d3izg8jazddalu.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
