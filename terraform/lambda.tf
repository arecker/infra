module "contact_sarah" {
  source     = "./modules/contact"
  identifier = "contact-sarah"
  sender_address = "reckeropsmailer@gmail.com"
  recipient_address = "sarah@reckerfamily.com"
  function_name = "contact-sarah-LambdaFunction-1VEH7J7CP6NH0"
  api_domain_name = "api.sarahrecker.com"
  hosted_zone_name = "sarahrecker.com."
  api_cloudfront_domain_name = "d3izg8jazddalu.cloudfront.net"
  message_subject = "New Message from {email}"
  message_body = <<EOF
Somebody filled out the contact form on your website:
---
{text}
EOF
}

module "contact_tranquility" {
  source     = "./modules/contact"
  identifier = "contact-tranquility"
  sender_address = "reckeropsmailer@gmail.com"
  recipient_address = "renee@tranquilitydesignsmn.com"
  function_name = "contact-tranquility-LambdaFunction-30BX8LXO57T6"
  api_domain_name = "api.tranquilitydesignsmn.com"
  hosted_zone_name = "tranquilitydesignsmn.com."
  api_cloudfront_domain_name = "dyjobn5aj21lk.cloudfront.net"
  message_subject = "New Visitor Contact from {name}"
  message_body = <<EOF
Hi Renee,

A website visitor has requested a consult with you.
---
{text}
---

Thanks,

Your Diligent Web Server
EOF
}
