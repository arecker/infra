data "aws_route53_zone" "zone" {
  name = "${var.hosted_zone_name}"
}

resource "aws_s3_bucket" "bucket" {
  acl	        = ""
  bucket_prefix = "${var.prefix}"

  website {
    index_document = "index.html"
    error_document  = "${var.error_document}"
    routing_rules  = "${var.routing_rules}"
  }

  tags = {
    Site = "${var.domain_name}"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": "*",
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled	  = true
  is_ipv6_enabled = true
  aliases	  = ["${var.domain_name}"]
  price_class	  = "PriceClass_100"
  http_version	  = "http1.1"

  default_cache_behavior {
    allowed_methods	   = ["HEAD", "GET"]
    cached_methods	   = ["HEAD", "GET"]
    target_origin_id	   = "bucket"
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = true
      
      cookies {
	forward = "none"
      }
    }
  }

  origin {
    origin_id   = "bucket"
    domain_name = "${aws_s3_bucket.bucket.website_endpoint}"
    
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
	"SSLv3",
	"TLSv1"
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method = "sni-only"
  }

  tags = {
    Site = "${var.domain_name}"
  }
}

resource "aws_route53_record" "record" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain_name}."
  type    = "A"
  
  alias {
    name		   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "redirect" {
  count = "${length(var.redirect_domain_names)}"
  acl   = ""

  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
}

resource "aws_cloudfront_distribution" "redirect_distribution" {
  count		  = "${length(var.redirect_domain_names)}"
  enabled	  = true
  is_ipv6_enabled = true
  aliases	  = ["${element(var.redirect_domain_names, count.index)}"]
  price_class	  = "PriceClass_100"
  http_version	  = "http1.1"

  default_cache_behavior {
    allowed_methods	   = ["HEAD", "GET"]
    cached_methods	   = ["HEAD", "GET"]
    target_origin_id	   = "redirect-bucket"
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = true
      
      cookies {
	forward = "none"
      }
    }
  }

  origin {
    origin_id   = "redirect-bucket"
    domain_name = "${element(aws_s3_bucket.redirect.*.website_endpoint, count.index)}"
    
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
	"SSLv3",
	"TLSv1"
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "redirect_record" {
  count	  = "${length(var.redirect_domain_names)}"
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${element(var.redirect_domain_names, count.index)}."
  type    = "A"

  alias {
    name		   = "${element(aws_cloudfront_distribution.redirect_distribution.*.domain_name, count.index)}"
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
