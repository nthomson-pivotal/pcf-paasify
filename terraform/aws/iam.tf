resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"

  provisioner "local-exec" {
    command = "sleep 20"
  }
}

resource "aws_iam_user" "user" {
  name = "paasify-${var.env_name}"
  path = "/paasify/"
}

resource "aws_iam_user_policy" "policy" {
  name = "paasify-${var.env_name}"
  user = "${aws_iam_user.user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
