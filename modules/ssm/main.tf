# resource "aws_ssm_parameter" "datadog_api" {
#   name  = "/buildroot-codebuild/datadog-api"
#   type  = "SecureString"
#   value = var.datadog_api
# }

# resource "aws_ssm_parameter" "signing_key" {
#   name  = "/buildroot-codebuild/signing-key"
#   type  = "SecureString"
#   value = var.signing_key
# }

resource "aws_ssm_parameter" "github_webhook_secret" {
  name  = "/${var.function_name}/master/GITHUB_WEBHOOK_SECRET"
  type  = "SecureString"
  value = var.github_webhook_secret
}

resource "aws_ssm_parameter" "buildroot_github_webhook_secret" {
  name  = "/${var.app_name}/${var.instance}/${var.function_name}/BUILDROOT_GITHUB_WEBHOOK_SECRET"
  type  = "SecureString"
  value = var.buildroot_github_webhook_secret
}

resource "aws_ssm_parameter" "github_access_token" {
  name  = "/${var.app_name}/${var.instance}/${var.function_name}/GITHUB_ACCESS_TOKEN"
  type  = "SecureString"
  value = var.github_access_token
}

resource "aws_ssm_parameter" "opentrons_github_webhook_secret" {
  name  = "/${var.app_name}/${var.instance}/${var.function_name}/OPENTRONS_GITHUB_WEBHOOK_SECRET"
  type  = "SecureString"
  value = var.opentrons_github_webhook_secret
}

resource "aws_ssm_parameter" "slack_webhook_url" {
  name  = "/${var.app_name}/${var.instance}/${var.s3_slack_update_function_name}/SLACK_WEBHOOK_URL"
  type  = "SecureString"
  value = var.slack_webhook_url
}




# resource "aws_ssm_parameter" "staging_release_notes_slack_webhook_url" {
#   name = "/${var.app_name}/staging-release-notes/${var.s3_slack_update_function_name}/SLACK_WEBHOOK_URL"
#   type = "SecureString"
#   value = var.staging_release_notes_slack_webhook_url
# }

# resource "aws_ssm_parameter" "staging_s3_slack_webhook_url" {
#   name = "/${var.app_name}/staging-s3-slack-webhook/${var.s3_slack_update_function_name}/SLACK_WEBHOOK_URL"
#   type = "SecureString"
#   value = var.staging_s3_slack_webhook_url
# }

# resource "aws_ssm_parameter" "staging_sdk_slack_webhook_url" {
#   name = "/${var.app_name}/staging-sdk/${var.s3_slack_update_function_name}/SLACK_WEBHOOK_URL"
#   type = "SecureString"
#   value = var.staging_sdk_slack_webhook_url
# }






# resource "aws_ssm_parameter" "dev_buildroot_github_webhook_secret" {
#   name = "/${var.app_name}/dev-seth/${var.function_name}/BUILDROOT_GITHUB_WEBHOOK_SECRET"
#   type = "SecureString"
#   value = var.dev_buildroot_github_webhook_secret
# }

# resource "aws_ssm_parameter" "dev_github_access_token" {
#   name = "/${var.app_name}/dev-seth/${var.function_name}/GITHUB_ACCESS_TOKEN"
#   type = "SecureString"
#   value = var.dev_github_access_token
# }

# resource "aws_ssm_parameter" "dev_opentrons_github_webhook_secret" {
#   name = "/${var.app_name}/dev-seth/${var.function_name}/OPENTRONS_GITHUB_WEBHOOK_SECRET"
#   type = "SecureString"
#   value = var.dev_opentrons_github_webhook_secret
# }

# resource "aws_ssm_parameter" "dev_slack_webhook_url" {
#   name = "/${var.app_name}/dev-seth/${var.s3_slack_update_function_name}/SLACK_WEBHOOK_URL"
#   type = "SecureString"
#   value = var.dev_slack_webhook_url
# }