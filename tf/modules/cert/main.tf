data "aws_route53_zone" "zone" {
  name = "${var.zone_name}"
}

resource "aws_acm_certificate" "cert" {
  domain_name		    = "${var.domain_name}"
  subject_alternative_names = "${var.alts}"
  validation_method	    = "DNS"
}

resource "aws_route53_record" "cert" {
  count	  = "${length(aws_acm_certificate.cert.domain_validation_options)}"
  name    = "${element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)}"
  type    = "${element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index)}"]
  ttl     = 60
}
