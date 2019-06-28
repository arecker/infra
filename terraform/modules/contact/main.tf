data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "zone" {
  name = "${var.hosted_zone_name}"
}

data "archive_file" "lambda_src" {
  type        = "zip"
  source_file = "${path.root}/lambdas/contact.py"
  output_path = "${path.root}/lambdas/builds/contact.zip"
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment_basic_execution" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "send-email-policy"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": [
        "arn:aws:ses:us-west-2:${data.aws_caller_identity.current.account_id}:identity/${var.sender_address}",
        "arn:aws:ses:us-west-2:${data.aws_caller_identity.current.account_id}:identity/${var.recipient_address}"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.function_name}"  # TODO: replace with ${var.identifier}
  filename      = "${data.archive_file.lambda_src.output_path}"
  handler       = "contact.handler"
  role	        = "${aws_iam_role.lambda_role.arn}"
  runtime       = "python3.6"
  environment {
    variables = {
      MessageBody      = "${var.message_body}"
      MessageSubject   = "${var.message_subject}"
      RecipientAddress = "${var.recipient_address}"
      SenderAddress    = "${var.sender_address}"
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.identifier}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "email"
}

resource "aws_api_gateway_method" "api_options_method" {
  rest_api_id	     = "${aws_api_gateway_rest_api.api.id}"
  resource_id	     = "${aws_api_gateway_resource.api_resource.id}"
  http_method	     = "OPTIONS"
  authorization	     = "NONE"
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "api_options_method_response" {
  rest_api_id	      = "${aws_api_gateway_rest_api.api.id}"
  resource_id	      = "${aws_api_gateway_resource.api_resource.id}"
  http_method	      = "${aws_api_gateway_method.api_options_method.http_method}"
  status_code	      = "200"
  response_models     = {}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "api_options_method_integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.api.id}"
  resource_id          = "${aws_api_gateway_resource.api_resource.id}"
  http_method          = "${aws_api_gateway_method.api_options_method.http_method}"
  type                 = "MOCK"
  request_templates = {
    "application/json" = "{statusCode:200}"
  }
}

resource "aws_api_gateway_integration_response" "api_options_method_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${aws_api_gateway_method.api_options_method.http_method}"
  status_code = "${aws_api_gateway_method_response.api_options_method_response.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method" "api_post_method" {
  rest_api_id	   = "${aws_api_gateway_rest_api.api.id}"
  resource_id	   = "${aws_api_gateway_resource.api_resource.id}"
  http_method	   = "POST"
  authorization	   = "NONE"
  api_key_required = false
  request_parameters = {}
}

resource "aws_api_gateway_integration" "api_post_method_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.api_resource.id}"
  http_method             = "${aws_api_gateway_method.api_post_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda_function.arn}/invocations"
}

# TODO: recreating
resource "aws_lambda_permission" "api_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*"
}

# TODO: recreating
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = ["aws_api_gateway_integration.api_post_method_integration"]
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "v1"
}

# TODO: recreating
resource "aws_api_gateway_base_path_mapping" "api_mapping" {
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.api_deployment.stage_name}"
  domain_name = "${var.api_domain_name}"
}

resource "aws_route53_record" "dns_record" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.api_domain_name}"
  type    = "A"

  alias {
    name		   = "${var.api_cloudfront_domain_name}"
    zone_id		   = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
