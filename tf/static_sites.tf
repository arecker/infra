module "blog_static_site" {
  source	        = "./modules/static_site"
  hosted_zone_name      = "alexrecker.com."
  domain_name	        = "www.alexrecker.com."
  redirect_domain_names = ["alexrecker.com."]
}
