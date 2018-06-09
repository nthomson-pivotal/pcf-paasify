resource "random_integer" "bucket" {
  min = 1
  max = 100000
}

locals {
  bucket_suffix = "${random_integer.bucket.result}"
}

resource "aws_s3_bucket" "mysql_bucket" {
  bucket        = "${var.env_name}-mysql-bucket-${local.bucket_suffix}"
  force_destroy = true

  tags {
    Name = "Elastic Runtime S3 MySQL backup bucket"
  }
}

resource "aws_iam_user" "mysql_backup" {
  name = "${var.env_name}_mysql_user"
}

resource "aws_iam_access_key" "mysql_backup" {
  user = "${aws_iam_user.mysql_backup.name}"
}

resource "aws_iam_user_policy" "mysql_backup" {
  name = "test"
  user = "${aws_iam_user.mysql_backup.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Sid": "ServiceBackupPolicy",
    "Effect": "Allow",
    "Action": [
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:CreateBucket",
      "s3:PutObject"
    ],
    "Resource": [
      "${aws_s3_bucket.mysql_bucket.arn}/*",
      "${aws_s3_bucket.mysql_bucket.arn}"
    ]
  }
  ]
}
EOF
}

data "template_file" "mysql_backup_configuration" {
  template = "${chomp(file("${path.module}/templates/mysql_backup_configuration.json"))}"

  vars {
    access_key = "${aws_iam_access_key.mysql_backup.id}"
    secret_access_key = "${aws_iam_access_key.mysql_backup.secret}"
    bucket_name = "${aws_s3_bucket.mysql_bucket.id}"
    region = "${var.region}"
  }
}
