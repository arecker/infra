module "alexandmarissa_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "alexandmarissa.com."
  domain_name = "www.alexandmarissa.com."
  alts	      = ["alexandmarissa.com."]
  providers   = {
    aws = "aws.virginia"
  }
}

module "alexrecker_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "alexrecker.com."
  domain_name = "alexrecker.com."
  alts	      = [
    "www.alexrecker.com."
  ]
  providers   = {
    aws = "aws.virginia"
  }
}

module "alexrecker_dot_com_archive_cert" {
  source      = "./modules/cert"
  zone_name   = "alexrecker.com."
  domain_name = "archive.alexrecker.com."
  alts	      = []
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

module "bobrosssearch_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "bobrosssearch.com."
  domain_name = "www.bobrosssearch.com."
  alts	      = ["bobrosssearch.com."]
  providers   = {
    aws = "aws.virginia"
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

module "tranquilitydesignsmn_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "tranquilitydesignsmn.com."
  domain_name = "tranquilitydesignsmn.com."
  alts	      = ["www.tranquilitydesignsmn.com", "api.tranquilitydesignsmn.com"]
  providers   = {
    aws = "aws.virginia"
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

module "sarahrecker_dot_com_scrabble_cert" {
  source      = "./modules/cert"
  zone_name   = "sarahrecker.com."
  domain_name = "scrabble.sarahrecker.com."
  providers   = {
    aws = "aws.virginia"
  }
}
