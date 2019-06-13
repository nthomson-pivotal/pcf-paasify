resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"

  provisioner "local-exec" {
    command = "sleep 20"
  }

  depends_on = [ "aws_iam_user_policy.policy" ]
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

resource "aws_iam_user" "pas_buckets" {
  name = "${var.env_name}_pas_buckets"
}

resource "aws_iam_access_key" "pas_buckets" {
  user = "${aws_iam_user.pas_buckets.name}"
}

resource "aws_iam_user_policy_attachment" "pas_buckets" {
  depends_on = ["module.aws"]

  user       = "${aws_iam_user.pas_buckets.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.env_name}_ert"
}

resource "aws_iam_role_policy" "opsman_patch" {
  depends_on = ["module.aws"]

  name = "${var.env_name}_om_patch"
  role = "${var.env_name}_om_role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DeregisterImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}