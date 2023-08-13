resource "aws_lambda_function" "s3_slack_update" {
  filename         = var.s3_slack_update_filename
  function_name    = "${var.instance}-${var.s3_slack_update_function_name}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.s3_slack_update_handler
  source_code_hash = filebase64sha256("./modules/lambdas/s3_slack_update.zip")
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  architectures    = var.architecture

  environment {
    variables = {
      APP_NAME  = var.app_name
      APP_STAGE = var.app_stage
      LOG_LEVEL = var.log_level
    }
  }
}


resource "aws_cloudwatch_log_group" "s3_slack_update" {
  name              = "/aws/lambda/${var.instance}-${var.s3_slack_update_function_name}"
  retention_in_days = 0
}

output "s3_slack_update_lambda_arn" {
  value = aws_lambda_function.s3_slack_update.arn
}