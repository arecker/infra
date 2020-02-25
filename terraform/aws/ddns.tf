# resource "aws_iam_user" "ddns" {
#   name = "ddns-role"
# }

# resource "aws_iam_user_policy" "ddns" {
#   name = "ddns-route53-policy"
#   user = "${aws_iam_user.ddns.name}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "route53:ChangeResourceRecordSets"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }
