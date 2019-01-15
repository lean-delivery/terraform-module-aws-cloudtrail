// setup CloudWatch LogGroup
resource "aws_cloudwatch_log_group" "cloudwatch" {
  count             = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"
  name              = "${local.default_name}-cloudtrail"
  retention_in_days = "${var.retention_period}"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch" {
  count           = "${ var.module_enabled && var.cloudwatch_enabled && lower(var.log_group_subscription_target_arn) != "none" ? 1 : 0 }"
  name            = "${local.default_name}-subscription"
  log_group_name  = "${aws_cloudwatch_log_group.cloudwatch.0.name}"
  filter_pattern  = ""
  destination_arn = "${var.log_group_subscription_target_arn}"
}

data "aws_iam_policy_document" "cloudwatch" {
  count = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudwatch.0.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudwatch.0.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "${aws_iam_role.cloudwatch.0.arn}",
    ]
  }
}

data "aws_iam_policy_document" "cloudwatch-subscription" {
  count = "${ var.module_enabled && var.cloudwatch_enabled && lower(var.log_group_subscription_target_arn) != "none" ? 1 : 0 }"

  statement {
    effect = "Allow"

    actions = [
      "logs:*",
    ]

    resources = [
      "${var.log_group_subscription_target_arn}",
    ]
  }
}

data "aws_iam_policy_document" "cloudwatch-allow-assume" {
  count = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.this.name}.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "cloudwatch" {
  count  = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"
  name   = "${local.default_name}-cloudtrail-cloudwatch"
  policy = "${data.aws_iam_policy_document.cloudwatch.0.json}"
}

resource "aws_iam_policy" "cloudwatch-subscription" {
  count  = "${ var.module_enabled && var.cloudwatch_enabled && lower(var.log_group_subscription_target_arn) != "none" ? 1 : 0 }"
  name   = "${local.default_name}-cloudtrail-cloudwatch-subscription"
  policy = "${data.aws_iam_policy_document.cloudwatch-subscription.0.json}"
}

resource "aws_iam_role" "cloudwatch" {
  count              = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"
  name               = "${local.default_name}-cloudtrail-cloudwatch"
  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch-allow-assume.json}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  count      = "${ var.module_enabled && var.cloudwatch_enabled ? 1 : 0 }"
  role       = "${aws_iam_role.cloudwatch.name}"
  policy_arn = "${aws_iam_policy.cloudwatch.arn}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-subscription" {
  count      = "${ var.module_enabled && var.cloudwatch_enabled && lower(var.log_group_subscription_target_arn) != "none" ? 1 : 0 }"
  role       = "${aws_iam_role.cloudwatch.name}"
  policy_arn = "${aws_iam_policy.cloudwatch-subscription.arn}"
}
