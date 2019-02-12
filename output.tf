output "s3_bucket_arn" {
  value       = "${element(concat(aws_s3_bucket.this.*.arn, list("")), 0)}"
  description = "ARN of S3 bucket"
}

output "s3_bucket_name" {
  value       = "${element(concat(aws_s3_bucket.this.*.id, list("")), 0)}"
  description = "Name of S3 bucket"
}

output "cloudwatch_log_group_arn" {
  value       = "${element(concat(aws_cloudwatch_log_group.cloudwatch.*.arn, list("")), 0)}"
  description = "CloudWatch Log Group ARN"
}

output "cloudwatch_log_group_name" {
  value       = "${element(concat(aws_cloudwatch_log_group.cloudwatch.*.name, list("")), 0)}"
  description = "CloudWatch Log Group name"
}

output "cloudtrail_name" {
  value       = "${element(concat(aws_cloudtrail.s3.*.id, aws_cloudtrail.s3-cloudwatch.*.id, list("")), 0)}"
  description = "Name of CloudTrail"
}

output "cloudtrail_arn" {
  value       = "${element(concat(aws_cloudtrail.s3.*.arn, aws_cloudtrail.s3-cloudwatch.*.arn, list("")), 0)}"
  description = "ARN of CloudTrail"
}
