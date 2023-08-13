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

variable "buildroot_ci_sns_topic_arn" {
  description = "Buildroot SNS topic ARN"
  type        = string
}

variable "buildroot_caching_bucket" {
  description = "Caching s3 bucket for buildroot"
  type        = string
}

variable "image" {
  description = "Docker image to use for build"
  type        = string
}

variable "build_log_group_name" {
  description = "Log group for Build"
  type        = string
}

variable "build_log_stream_name" {
  description = "Log stream for Build"
  type        = string
}

variable "main_source_url" {
  description = "Main source URL e.g https://github.com/<user-name>/<repository-name>"
  type        = string
}

variable "secondary_source_url" {
  description = "Secondary source URL e.g https://github.com/<user-name>/<repository-name>"
  type        = string
}

variable "source_token" {
  description = "Token to be used in authenticating to source"
  type        = string
}

variable "secondary_source_identifier" {
  description = "Secondary source identifier"
  type        = string
}

variable "build_env" {
  description = "Type of build environment to use for related builds"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "build_compute_type" {
  description = "Compute resource type the builds will use"
  type        = string
  default     = "BUILD_GENERAL1_LARGE"
}