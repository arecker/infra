resource "aws_s3_bucket" "bucket" {
  acl	        = ""
  bucket_prefix = "${var.prefix}"

  website {
    index_document = "index.html"
    routing_rules  = "${var.routing_rules}"
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

resource "aws_s3_bucket" "redirect" {
  count = "${length(var.redirect_domain_names)}"
  acl   = ""

  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
}
