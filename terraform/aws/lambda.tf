module "contact_tranquility" {
  source     = "../modules/contact"
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
