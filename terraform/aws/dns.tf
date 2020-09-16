locals {
  github_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

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
  source = "../modules/privateemail"
  zone_name = "alexandmarissa.com."
}

resource "aws_route53_record" "alexandmarissa_dot_com_cname" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "www.alexandmarissa.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "arecker.github.io."
  ]
}

resource "aws_route53_record" "alexandmarissa_dot_com_apex" {
  zone_id = "${aws_route53_zone.alexandmarissa_dot_com.zone_id}"
  name    = "alexandmarissa.com."
  type    = "A"
  ttl     = "300"
  records = local.github_ips
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

resource "aws_route53_record" "alexrecker_dot_com_cname" {
  zone_id	  = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name		  = "www.alexrecker.com."
  type		  = "CNAME"
  ttl		  = "300"
  records	  = [
    "arecker-blog.netlify.com."
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "alexrecker_dot_com_apex" {
  zone_id	  = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name		  = "alexrecker.com."
  type		  = "A"
  ttl		  = "300"
  records	  = ["104.198.14.52"]
  allow_overwrite = true
}

resource "aws_route53_record" "alexrecker_dot_com_demo_cname" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "demo.alexrecker.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "arecker.github.io."
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_archive_cname" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name    = "archive.alexrecker.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "arecker.github.io."
  ]
}

resource "aws_route53_record" "alexrecker_dot_com_txt" {
  zone_id = "${aws_route53_zone.alexrecker_dot_com.zone_id}"
  name	  = "alexrecker.com."
  type	  = "TXT"
  ttl	  = "300"
  records = [
    "google-site-verification=ETLppNnA0WVMiSfqYwpsCJeDC-emoZhTy3xnyEJXr_Y"
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

resource "aws_route53_record" "bobrosssearch_dot_com_cname" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "www.bobrosssearch.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "arecker.github.io."
  ]
}

resource "aws_route53_record" "bobrosssearch_dot_com_apex" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "bobrosssearch.com."
  type    = "A"
  ttl     = "300"
  records = local.github_ips
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

resource "aws_route53_record" "reckerfamily_dot_com_cookbook_cname" {
  zone_id = "${aws_route53_zone.reckerfamily_dot_com.zone_id}"
  name    = "cookbook.reckerfamily.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "readthedocs.io."
  ]
}

module "reckerfamily_dot_com_gmail" {
  source = "../modules/gmail"
  zone_name = "reckerfamily.com."
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
  zone_id	  = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name		  = "tranquilitydesignsmn.com."
  type		  = "A"
  ttl		  = "300"
  records	  = local.github_ips
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

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_api_cert" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "_5bfba514fa57efad86cc0f606c890464.api.tranquilitydesignsmn.com."
  type    = "CNAME"
  ttl     = "300"
  records = [
    "_e8fb87937c1cf4f5a6fa7dd3097368c3.acm-validations.aws."
  ]
  allow_overwrite = true
}


module "tranquilitydesignsmn_dot_com_privateemail" {
  source = "../modules/privateemail"
  zone_name = "tranquilitydesignsmn.com."
}
