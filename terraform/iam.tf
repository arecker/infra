resource "aws_iam_user" "public_travis" {
  name = "public-travis-service"
}

resource "aws_iam_user_policy_attachment" "public_travis_attachment" {
  user       = "${aws_iam_user.public_travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "infra_travis" {
  name = "infra-travis-service"
}

resource "aws_iam_user_policy_attachment" "infra_travis_attachment" {
  user       = "${aws_iam_user.infra_travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "cache-invalidate-policy"
  user = "${aws_iam_user.public_travis.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetDistribution",
        "cloudfront:ListDistributions",
        "cloudfront:ListTagsForResource"
      ]
    }
  ]
}
EOF
}
