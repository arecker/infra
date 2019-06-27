resource "aws_s3_bucket" "lambda_bucket" {
  bucket_prefix = "recker-lambda-"
  acl	        = "private"
}

resource "aws_s3_bucket_object" "contact" {
  bucket = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "contact.py"
  source = "lambdas/contact.py"
  etag	 = "${filemd5("lambdas/contact.py")}"
}
