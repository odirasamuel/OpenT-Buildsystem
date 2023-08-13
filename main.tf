module "test_codebuild" {
  source                      = "./modules/codebuild"
  instance                    = var.instance
  env                         = var.env
  codebuild_project_name      = var.codebuild_project_name
  buildroot_ci_sns_topic_arn  = module.test_sns.buildroot_ci_sns_topic_arn
  buildroot_caching_bucket    = var.buildroot_caching_bucket
  image                       = var.image
  build_log_group_name        = var.build_log_group_name
  build_log_stream_name       = var.build_log_stream_name
  main_source_url             = var.main_source_url
  secondary_source_url        = var.secondary_source_url
  source_token                = var.source_token
  secondary_source_identifier = var.secondary_source_identifier
}

module "test_lambdas" {
  source                          = "./modules/lambdas"
  app_name                        = var.app_name
  app_stage                       = var.app_stage
  log_level                       = var.log_level
  instance                        = var.instance
  env                             = var.env
  codebuild_project_name          = var.codebuild_project_name
  github_webhook_secret           = module.test_ssm.parameters.github_webhook_secret.arn
  buildroot_github_webhook_secret = module.test_ssm.parameters.buildroot_github_webhook_secret.arn
  github_access_token             = module.test_ssm.parameters.github_access_token.arn
  filename                        = var.filename
  function_name                   = var.function_name
  handler                         = var.handler
  runtime                         = var.runtime
  memory_size                     = var.memory_size
  timeout                         = var.timeout
  rest_api_name                   = var.rest_api_name
  api_resource_path               = var.api_resource_path
  api_stage_name                  = var.api_stage_name
  s3_slack_update_filename        = var.s3_slack_update_filename
  s3_slack_update_function_name   = var.s3_slack_update_function_name
  sns_topic_name                  = var.sns_topic_name
  s3_slack_update_handler         = var.s3_slack_update_handler
}

module "test_sns" {
  source                     = "./modules/sns"
  env                        = var.env
  instance                   = var.instance
  sns_topic_name             = var.sns_topic_name
  display_name               = var.display_name
  buildroot_ci_bucket_arn    = module.test_codebuild.buildroot_ci_bucket_arn
  s3_slack_update_lambda_arn = module.test_lambdas.s3_slack_update_lambda_arn
}

module "test_ssm" {
  source                          = "./modules/ssm"
  env                             = var.env
  instance                        = var.instance
  github_webhook_secret           = var.github_webhook_secret
  buildroot_github_webhook_secret = var.buildroot_github_webhook_secret
  github_access_token             = var.github_access_token
  opentrons_github_webhook_secret = var.opentrons_github_webhook_secret
  slack_webhook_url               = var.slack_webhook_url
  function_name                   = var.function_name
  app_name                        = var.app_name
  s3_slack_update_function_name   = var.s3_slack_update_function_name
}