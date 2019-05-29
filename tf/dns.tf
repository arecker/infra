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

resource "aws_route53_record" "bobrosssearch_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "_73a1a2bde3ada19783c8874703f40178.bobrosssearch.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_ecb5d704f17adb5734597fc095a0f621.acm-validations.aws."
  ]
}

resource "aws_route53_record" "bobrosssearch_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.bobrosssearch_dot_com.zone_id}"
  name    = "_4c1fa76ab065386305f88408b1c5a110.www.bobrosssearch.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_6568253aebf6762a52c4a3aff694cdfa.acm-validations.aws."
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

resource "aws_route53_record" "reckerfamily_dot_com_mx" {
  zone_id = "${aws_route53_zone.reckerfamily_dot_com.zone_id}"
  name    = "reckerfamily.com"
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

resource "aws_route53_record" "fromdirktolight_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "_e06a65824a8d684f9400acb0a4c1aff3.fromdirktolight.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_8b600fdb543c05bf2002a0037ef80f0e.acm-validations.aws."
  ]
}


resource "aws_route53_record" "fromdirktolight_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.fromdirktolight_dot_com.zone_id}"
  name    = "_e979a33ba9a26bb4378b1ed420c9b574.www.fromdirktolight.com"
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_b354d4481e1216fd9cf6a283a4d5d8ef.acm-validations.aws."
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

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "_558238ef010d11dbe632d392943988d5.tranquilitydesignsmn.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_7316d0699714bf38571ab2e0610cd2f8.acm-validations.aws.",
  ]
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "_e1bf33ddf9b6f9d90fd6812be7437d9e.www.tranquilitydesignsmn.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_66f1c0e425905e885823c1bfa6b38783.acm-validations.aws.",
  ]
}

resource "aws_route53_record" "tranquilitydesignsmn_dot_com_ssl2" {
  zone_id = "${aws_route53_zone.tranquilitydesignsmn_dot_com.zone_id}"
  name    = "_5bfba514fa57efad86cc0f606c890464.api.tranquilitydesignsmn.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_e8fb87937c1cf4f5a6fa7dd3097368c3.acm-validations.aws.",
  ]
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

resource "aws_route53_record" "sarahrecker_dot_com_ssl0" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "_a904d2f1c37e9ed523909903104e2f4f.sarahrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_c55fcb6d34cbd7fae0fd2dd3ebe57349.acm-validations.aws."
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_ssl1" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "_65aa3f939c04fc0ba16c47b7f32380bc.api.sarahrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_4c3d9f0d2edd74694cdcc7c3026ea0c8.acm-validations.aws."
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_ssl2" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "_8a25dcb0990177b5dc4abc65c00d4aad.blog.sarahrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_0d9318ed6bee8625c5ccf4fc53a77e87.acm-validations.aws."
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_ssl3" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "_ef5a516a3c3d85fbef582251d326ab25.scrabble.sarahrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_347230f0b7e6715ad4114a103a51ef5b.acm-validations.aws."
  ]
}

resource "aws_route53_record" "sarahrecker_dot_com_ssl4" {
  zone_id = "${aws_route53_zone.sarahrecker_dot_com.zone_id}"
  name    = "_85dbd81e1ba1f2f4787472ded24d2579.www.sarahrecker.com."
  type    = "CNAME"
  ttl     = "60"
  records = [
    "_e971b76034430720efb59876fa9dffb7.acm-validations.aws."
  ]
}
