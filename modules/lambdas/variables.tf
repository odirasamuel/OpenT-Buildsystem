variable "app_name" {
  description = "App Name"
  type        = string
}

variable "app_stage" {
  description = "Stage Name"
  type        = string
}

variable "log_level" {
  description = "Log level of details"
  type        = string
  default     = "debug"
}

variable "instance" {
  description = "Instance of an environment"
  type        = string
}

variable "env" {
  description = "Environment (prod or dev)"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "github_webhook_secret" {
  description = "Github webhook secret"
  type        = string
}

variable "buildroot_github_webhook_secret" {
  description = "Buildroot webhook secret"
  type        = string
}

variable "github_access_token" {
  description = "Githun access token"
  type        = string
}

variable "filename" {
  description = "Zipped filename containing the Lambda configurations"
  type        = string
}

variable "function_name" {
  description = "Webhook Lambda function's name"
  type        = string
}

variable "handler" {
  description = "Function's entry point"
  type        = string
}

variable "runtime" {
  description = "Function's runtime"
  type        = string
}

variable "memory_size" {
  description = "Function's memory size"
  type        = number
}

variable "timeout" {
  description = "Function's timeout"
  type        = number
}

variable "architecture" {
  description = "Architecture"
  type        = list(string)
  default     = ["x86_64"]
}

variable "rest_api_name" {
  description = "Name of Rest API"
  type        = string
}

variable "api_resource_path" {
  description = "REST API resource part"
  type        = string
}

variable "api_stage_name" {
  description = "Stage name for REST API"
  type        = string
}

variable "s3_slack_update_filename" {
  description = "Zipped filename containing the Lambda configurations"
  type        = string
}

variable "s3_slack_update_function_name" {
  description = "Lambda function's name"
  type        = string
}

variable "sns_topic_name" {
  description = "Name of SNS topic"
  type        = string
}

variable "s3_slack_update_handler" {
  description = "Function's entry point"
  type        = string
}