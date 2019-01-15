// setup S3 for CloudTrail logs
resource "aws_s3_bucket" "this" {
  count         = "${ var.module_enabled ? 1 : 0 }"
  bucket        = "${local.default_name}-cloudtrail"
  force_destroy = "${ lower(substr(var.environment, 0, 4)) == "prod" ? "false" : "true" }"

  lifecycle_rule {
    enabled = "true"

    noncurrent_version_expiration {
      days = 365
    }
  }

  tags = "${local.default_tags}"
}

data "aws_iam_policy_document" "allow-get-bucket-acl" {
  count = "${ var.module_enabled ? 1 : 0 }"

  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "${aws_s3_bucket.this.0.arn}",
    ]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow-put-object" {
  count       = "${ var.module_enabled ? 1 : 0 }"
  source_json = "${data.aws_iam_policy_document.allow-get-bucket-acl.0.json}"

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.0.arn}/*",
    ]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "attach-allow-put-object" {
  count  = "${ var.module_enabled ? 1 : 0 }"
  bucket = "${aws_s3_bucket.this.0.id}"
  policy = "${data.aws_iam_policy_document.allow-put-object.0.json}"
}
