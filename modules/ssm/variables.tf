variable "github_webhook_secret" {
  description = "Github webhook secret for master"
  type        = string
}

variable "buildroot_github_webhook_secret" {
  description = "Prod buildroot github webhook secret"
  type        = string
}

variable "github_access_token" {
  description = "Prod github access token"
  type        = string
}

variable "opentrons_github_webhook_secret" {
  description = "Prod opentrons github webhook secret"
  type        = string
}

variable "slack_webhook_url" {
  description = "Prod slack webhook url"
  type        = string
}

variable "function_name" {
  description = "Webhook Lambda function's name"
  type        = string
}

variable "app_name" {
  description = "App Name"
  type        = string
}

variable "instance" {
  description = "Instance of an environment"
  type        = string
}

variable "env" {
  description = "Environment (prod or dev)"
  type        = string
}

variable "s3_slack_update_function_name" {
  description = "Lambda function's name"
  type        = string
}

# variable "staging_release_notes_slack_webhook_url" {
#   description = "Staging release notes slack webhook url"
#   type        = string
# }

# variable "staging_s3_slack_webhook_url" {
#   description = "Staging s3 slack webhook url"
#   type        = string
# }

# variable "staging_sdk_slack_webhook_url" {
#   description = "Staging SDK slack webhook url"
#   type        = string
# }

# variable "dev_buildroot_github_webhook_secret" {
#   description = "Dev buildroot github webhook secret"
#   type        = string
# }

# variable "dev_github_access_token" {
#   description = "Dev github access token"
#   type        = string
# }

# variable "dev_opentrons_github_webhook_secret" {
#   description = "Dev opentrons github webhook secret"
#   type        = string
# }

# variable "dev_slack_webhook_url" {
#   description = "Dev slack webhook url"
#   type        = string
# }

# variable "datadog_api" {
#   description = "Datadog API Key for buildroot codebuild"
#   type        = string
# }

# variable "signing_key" {
#   description = "Buildroot codebuild signing key"
#   type        = string
# }