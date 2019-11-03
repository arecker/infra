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

module "tranquilitydesignsmn_dot_com_cert" {
  source      = "./modules/cert"
  zone_name   = "tranquilitydesignsmn.com."
  domain_name = "tranquilitydesignsmn.com."
  alts	      = ["www.tranquilitydesignsmn.com", "api.tranquilitydesignsmn.com"]
  providers   = {
    aws = "aws.virginia"
  }
}
