variable "sns_topic_name" {
  description = "Name of SNS topic"
  type        = string
}

variable "display_name" {
  description = "Display name of SNS topic"
  type        = string
}

variable "buildroot_ci_bucket_arn" {
  description = "ARN of the buildroot CI s3 bucket"
  type        = string
}

variable "env" {
  description = "Environment (prod or dev)"
  type        = string
}

variable "instance" {
  description = "Instance of an environment"
  type        = string
}

variable "s3_slack_update_lambda_arn" {
  description = "S3 slack lambda function ARN"
  type        = string
}