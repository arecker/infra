data "local_file" "blog_redirects" {
    filename = "${path.module}/redirects/blog.json"
}

module "blog_static_site" {
  source	        = "./modules/static_site"
  hosted_zone_name      = "alexrecker.com."
  domain_name	        = "www.alexrecker.com"
  redirect_domain_names = ["alexrecker.com"]
  cert_arn	        = "${module.alexrecker_dot_com_cert.arn}"
  routing_rules	        = "${data.local_file.blog_redirects.content}"
  default_ttl	        = "3600"
}

module "tranquility_static_site" {
  source	        = "./modules/static_site"
  hosted_zone_name      = "tranquilitydesignsmn.com."
  domain_name	        = "www.tranquilitydesignsmn.com"
  redirect_domain_names = ["tranquilitydesignsmn.com"]
  cert_arn	        = "${module.tranquilitydesignsmn_dot_com_cert.arn}"
  error_document        = "404/index.html"
  providers   = {
    aws = "aws.oregon"
  }
}
