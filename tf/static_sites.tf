module "blog_static_site" {
  source	        = "./modules/static_site"
  hosted_zone_name      = "alexrecker.com."
  domain_name	        = "www.alexrecker.com"
  redirect_domain_names = ["alexrecker.com"]
  routing_rules = <<RULES
[{
    "Condition": {
	"KeyPrefixEquals": "our-new-sid-meiers-civilization-inspired-budget/"
    },
    "Redirect": {
	"Hostname": "www.alexrecker.com",
	"Protocol": "https",
	"ReplaceKeyWith": "civ-budget.html"
    }
},
{
    "Condition": {
	"KeyPrefixEquals": "using-selenium-buy-bus-pass/"
    },
    "Redirect": {
	"Hostname": "www.alexrecker.com",
	"Protocol": "https",
	"ReplaceKeyWith": "selenium-bus-pass.html"
    }
}]
RULES
}
