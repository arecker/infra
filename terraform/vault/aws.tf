locals {
  access_key_path = "${path.root}/secrets/aws-access-key"
  secret_key_path = "${path.root}/secrets/aws-secret-key"
}

resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_secret_backend" "aws" {
  access_key = file(local.access_key_path)
  secret_key = file(local.secret_key_path)
}

resource "aws_iam_user" "vault" {
  name = "vault"
}

locals {
  assume_from_vault = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_user.vault.arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ddns" {
  name		     = "ddns"
  assume_role_policy = local.assume_from_vault
}

resource "aws_iam_role_policy" "ddns" {
  name	 = "ddns-policy"
  role	 = aws_iam_role.ddns.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
	"route53:ChangeResourceRecordSets"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}
