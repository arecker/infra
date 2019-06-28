resource "aws_iam_user" "public_travis" {
  name = "public-travis-service"
}

resource "aws_iam_user_policy_attachment" "public_travis_attachment" {
  user       = "${aws_iam_user.public_travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
