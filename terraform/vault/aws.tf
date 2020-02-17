data "aws_caller_identity" "current" {}

locals {
  account_id        = data.aws_caller_identity.current.account_id
  access_key_path   = "${path.root}/secrets/aws-access-key"
  secret_key_path   = "${path.root}/secrets/aws-secret-key"
  vault_user_arn    = "arn:aws:iam::${local.account_id}:user/vault"
  assume_from_vault = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${local.vault_user_arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_secret_backend" "aws" {
  access_key = chomp(file(local.access_key_path))
  secret_key = chomp(file(local.secret_key_path))
}

resource "aws_iam_user_policy" "vault" {
  name	 = "vault-policy"
  user	 = "vault"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "sts:AssumeRole"
    ],
    "Resource": "arn:aws:iam::${local.account_id}:role/vault/*"
  }
}
EOF
}

resource "aws_iam_role" "ddns" {
  name		     = "ddns"
  path		     = "/vault/"
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

resource "vault_aws_secret_backend_role" "ddns" {
  backend	  = vault_aws_secret_backend.aws.path
  name		  = "ddns"
  credential_type = "assumed_role"
  role_arns	  = [aws_iam_role.ddns.arn]
}
