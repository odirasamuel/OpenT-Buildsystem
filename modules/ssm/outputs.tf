output "parameters" {
  value = {
    # datadog_api = {
    #   name = aws_ssm_parameter.datadog_api.name
    #   arn  = aws_ssm_parameter.datadog_api.arn
    # }
    # signing_key = {
    #   name = aws_ssm_parameter.signing_key.name
    #   arn  = aws_ssm_parameter.signing_key.arn
    # }
    github_webhook_secret = {
      name = aws_ssm_parameter.github_webhook_secret.name
      arn  = aws_ssm_parameter.github_webhook_secret.arn
    }
    buildroot_github_webhook_secret = {
      name = aws_ssm_parameter.buildroot_github_webhook_secret.name
      arn  = aws_ssm_parameter.buildroot_github_webhook_secret.arn
    }
    github_access_token = {
      name = aws_ssm_parameter.github_access_token.name
      arn  = aws_ssm_parameter.github_access_token.arn
    }
    opentrons_github_webhook_secret = {
      name = aws_ssm_parameter.opentrons_github_webhook_secret.name
      arn  = aws_ssm_parameter.opentrons_github_webhook_secret.arn
    }
    slack_webhook_url = {
      name = aws_ssm_parameter.slack_webhook_url.name
      arn  = aws_ssm_parameter.slack_webhook_url.arn
    }
    # staging_release_notes_slack_webhook_url = {
    #     name = aws_ssm_parameter.staging_release_notes_slack_webhook_url.name
    #     arn = aws_ssm_parameter.staging_release_notes_slack_webhook_url.arn
    # }
    # staging_s3_slack_webhook_url = {
    #     name = aws_ssm_parameter.staging_s3_slack_webhook_url.name
    #     arn = aws_ssm_parameter.staging_s3_slack_webhook_url.arn
    # }
    # staging_sdk_slack_webhook_url = {
    #     name = aws_ssm_parameter.staging_sdk_slack_webhook_url.name
    #     arn = aws_ssm_parameter.staging_sdk_slack_webhook_url.arn
    # }
    # dev_buildroot_github_webhook_secret = {
    #     name = aws_ssm_parameter.dev_buildroot_github_webhook_secret.name
    #     arn = aws_ssm_parameter.dev_buildroot_github_webhook_secret.arn
    # }
    # dev_github_access_token = {
    #     name = aws_ssm_parameter.dev_github_access_token.name
    #     arn = aws_ssm_parameter.dev_github_access_token.arn
    # }
    # dev_opentrons_github_webhook_secret = {
    #     name = aws_ssm_parameter.dev_opentrons_github_webhook_secret.name
    #     arn = aws_ssm_parameter.dev_opentrons_github_webhook_secret.arn
    # }
    # dev_slack_webhook_url = {
    #     name = aws_ssm_parameter.dev_slack_webhook_url.name
    #     arn = aws_ssm_parameter.dev_slack_webhook_url.arn
    # }
  }
}