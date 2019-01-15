locals {
  default_name = "${var.project}-${var.environment}"

  default_tags = {
    Name        = "${var.project}-${var.environment}"
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

data "aws_region" "this" {}

// setup CloudTrail
resource "aws_cloudtrail" "s3" {
  depends_on                    = ["aws_s3_bucket_policy.attach-allow-put-object"]
  count                         = "${ var.module_enabled && !var.cloudwatch_enabled ? 1 : 0 }"
  name                          = "${local.default_name}"
  enable_logging                = "true"
  is_multi_region_trail         = "true"
  include_global_service_events = "true"
  enable_log_file_validation    = "true"

  s3_bucket_name = "${aws_s3_bucket.this.0.id}"

  tags = "${local.default_tags}"
}

resource "aws_cloudtrail" "s3-cloudwatch" {
  depends_on                    = ["aws_s3_bucket_policy.attach-allow-put-object"]
  count                         = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"
  name                          = "${local.default_name}"
  enable_logging                = "true"
  is_multi_region_trail         = "true"
  include_global_service_events = "true"
  enable_log_file_validation    = "true"

  s3_bucket_name = "${aws_s3_bucket.this.0.id}"

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch.arn}"
  cloud_watch_logs_role_arn  = "${aws_iam_role.cloudwatch.arn}"

  tags = "${local.default_tags}"
}
