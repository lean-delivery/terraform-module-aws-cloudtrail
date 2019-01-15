variable "project" {
  description = "Project name will be used for naming resources in pattern %PROJECT_NAME%-%ENVIRONMENT_NAME%"
  default     = "project"
}

variable "environment" {
  description = "Environment name will be used for naming resources in pattern %PROJECT_NAME%-%ENVIRONMENT_NAME%"
  default     = "test"
}

variable "module_enabled" {
  description = "Trigger to enable/disable module"
  default     = "true"
}

variable "cloudwatch_enabled" {
  description = "Trigger to enable/disable cloudwatch option"
  default     = "false"
}

variable "retention_period" {
  description = "CloudWatch log retention period in days"
  default     = 7
}

variable "log_group_subscription_target_arn" {
  description = "CloudWatch Log Group Subscription target ARN (disabled by default)"
  default     = "None"
}
