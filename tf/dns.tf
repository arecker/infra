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

module "alexandmarissa_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "alexandmarissa.com."
  domain_name = "www.alexandmarissa.com."
  alts	      = ["alexandmarissa.com."]
  providers   = {
    aws = "aws.virginia"
  }
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

module "alexrecker_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "alexrecker.com."
  domain_name = "alexrecker.com."
  alts	      = ["www.alexrecker.com."]
  providers   = {
    aws = "aws.virginia"
  }
}

module "alexrecker_dot_com_demo_cert" {
  source      = "./modules/cert"
  zone_name   = "alexrecker.com."
  domain_name = "demo.alexrecker.com."
  providers   = {
    aws = "aws.virginia"
  }
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

resource "aws_route53_record" "bobrosssearch_dot_com_a" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "bobrosssearch.com."
  type    = "A"
  
  alias {
    name		   = "d1a95v21kdxtjw.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "bobrosssearch_dot_com_www" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "www.bobrosssearch.com."
  type    = "A"
  
  alias {
    name		   = "d3snz2qkf290ka.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

module "bobrosssearch_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "bobrosssearch.com."
  domain_name = "www.bobrosssearch.com."
  alts	      = ["bobrosssearch.com."]
  providers   = {
    aws = "aws.virginia"
  }
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

resource "aws_route53_record" "fromdirktolight_dot_com_a" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "fromdirktolight.com."
  type    = "A"
  
  alias {
    name		   = "d10wa54uok5gih.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "fromdirktolight_dot_com_www" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "www.fromdirktolight.com."
  type    = "A"
  
  alias {
    name		   = "d9c0iecujw0rs.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

module "fromdirktolight_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "fromdirktolight.com."
  domain_name = "www.fromdirktolight.com."
  alts	      = ["fromdirktolight.com."]
  providers   = {
    aws = "aws.virginia"
  }
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

module "tranquilitydesignsmn_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "tranquilitydesignsmn.com."
  domain_name = "tranquilitydesignsmn.com."
  alts	      = ["www.tranquilitydesignsmn.com", "api.tranquilitydesignsmn.com"]
  providers   = {
    aws = "aws.virginia"
  }
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_www" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "www.tranquilitydesignsmn.com."
  type    = "A"
  
  alias {
    name		   = "d2yuq653oms14x.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
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

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_a" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "tranquilitydesignsmn.com."
  type    = "A"
  
  alias {
    name		   = "dg1hw91licdcu.cloudfront.net."
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

resource "aws_route53_record" "sarahrecker_dot_com_www" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "www.sarahrecker.com"
  type    = "A"

  alias {
    name		   = "d4xdd2h2u5l7f.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "sarahrecker_dot_com_a" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "sarahrecker.com"
  type    = "A"
  
  alias {
    name		   = "d1f8nrarxovqty.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "sarahrecker_dot_com_scrabble" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "scrabble.sarahrecker.com"
  type    = "A"
  
  alias {
    name		   = "difhkd31sdw77.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "sarahrecker_dot_com_blog" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "blog.sarahrecker.com"
  type    = "A"
  
  alias {
    name		   = "d23ncahpyaiu9j.cloudfront.net."
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

module "sarahrecker_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "sarahrecker.com."
  domain_name = "www.sarahrecker.com."
  alts	      = ["sarahrecker.com."]
  providers   = {
    aws = "aws.virginia"
  }
}

module "sarahrecker_dot_com_blog_cert" {
  source      = "./modules/cert"
  zone_name   = "sarahrecker.com."
  domain_name = "blog.sarahrecker.com."
  providers   = {
    aws = "aws.virginia"
  }
}

module "sarahrecker_dot_com_api_cert" {
  source      = "./modules/cert"
  zone_name   = "sarahrecker.com."
  domain_name = "api.sarahrecker.com."
  providers   = {
    aws = "aws.virginia"
  }
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
