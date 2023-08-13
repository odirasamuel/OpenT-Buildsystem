data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "opent_buildroot_webhook" {
  filename         = var.filename
  function_name    = "${var.instance}-${var.function_name}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = filebase64sha256("./modules/lambdas/opent_buildroot_webhook.zip")
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  architectures    = var.architecture

  environment {
    variables = {
      APP_NAME                        = var.app_name
      APP_STAGE                       = var.app_stage
      LOG_LEVEL                       = var.log_level
      OPENT_GITHUB_WEBHOOK_SECRET = var.github_webhook_secret
      BUILDROOT_GITHUB_WEBHOOK_SECRET = var.buildroot_github_webhook_secret
      GITHUB_ACCESS_TOKEN             = var.github_access_token
    }
  }
}

resource "aws_cloudwatch_log_group" "opent_buildroot_webhook" {
  name              = "/aws/lambda/${aws_lambda_function.opent_buildroot_webhook.function_name}"
  retention_in_days = 0
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.app_name}-${var.instance}-lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy" "lambda_role_logging" {
  name = "${var.app_name}-${var.instance}-lambdaRole-logging-policy"
  role = aws_iam_role.lambda_role.name
  policy = templatefile("./modules/policies/lambda_cloudwatch.json", {
    buildroot_log_group_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.opent_buildroot_webhook.function_name}:*",
    s3_slack_update_arn     = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.instance}-${var.s3_slack_update_function_name}:*"
  })
}

resource "aws_iam_role_policy" "lambda_role_ssm_parameters" {
  name = "${var.app_name}-${var.instance}-lambdaRole-ssm-parameters-policy"
  role = aws_iam_role.lambda_role.name
  policy = templatefile("./modules/policies/lambda_ssm.json", {
    parameters_arn = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.app_name}/${var.instance}/*"
  })
}

resource "aws_iam_role_policy" "lambda_role_codebuild" {
  name = "${var.app_name}-${var.instance}-lambdaRole-codebuild-policy"
  role = aws_iam_role.lambda_role.name
  policy = templatefile("./modules/policies/lambda_codebuild.json", {
    codebuild_arn = "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:project/${var.codebuild_project_name}"
  })
}

resource "aws_iam_role_policy" "lambda_role_buildroot_ci" {
  name = "${var.app_name}-${var.instance}-lambdaRole-buildroot-ci-policy"
  role = aws_iam_role.lambda_role.name
  policy = templatefile("./modules/policies/lambda_s3.json", {
    s3_arn = "arn:aws:s3:::${var.codebuild_project_name}-ci"
  })
}

resource "aws_iam_role_policy" "lambda_role_sns" {
  name = "${var.app_name}-${var.instance}-lambdaRole-sns-policy"
  role = aws_iam_role.lambda_role.name
  policy = templatefile("./modules/policies/lambda_sns.json", {
    sns_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}"
  })
}

#API
resource "aws_api_gateway_rest_api" "opent_devops_api" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "opent_devops_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.opent_devops_api.id
  parent_id   = aws_api_gateway_rest_api.opent_devops_api.root_resource_id
  path_part   = var.api_resource_path
}

resource "aws_api_gateway_method" "opent_devops_api_resource_method" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.opent_devops_api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.opent_devops_api.id
}

resource "aws_api_gateway_integration" "opent_devops_api_resource_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.opent_devops_api.id
  resource_id             = aws_api_gateway_resource.opent_devops_api_resource.id
  http_method             = aws_api_gateway_method.opent_devops_api_resource_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.opent_buildroot_webhook.arn
}

resource "aws_lambda_permission" "opent_buildroot_webhook" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.opent_buildroot_webhook.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.opent_devops_api.id}/*/${aws_api_gateway_method.opent_devops_api_resource_method.http_method}${aws_api_gateway_resource.opent_devops_api_resource.path}"
}

resource "aws_api_gateway_deployment" "opent_devops_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.opent_devops_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.opent_devops_api_resource.id,
      aws_api_gateway_method.opent_devops_api_resource_method.id,
      aws_api_gateway_integration.opent_devops_api_resource_method_integration.id
    ]))
  }
}

resource "aws_api_gateway_stage" "opent_devops_api_stage" {
  deployment_id = aws_api_gateway_deployment.opent_devops_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.opent_devops_api.id
  stage_name    = var.api_stage_name
}