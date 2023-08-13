data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "buildroot_ci_sns_topic" {
  name         = var.sns_topic_name
  display_name = var.display_name

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "__default_policy_ID"
    Statement = [
      {
        Sid    = "__default_statement_ID"
        Effect = "Allow",
        Principal = {
          AWS = ["*"]
        }
        Action = [
          "SNS:Publish",
          "SNS:RemovePermission",
          "SNS:SetTopicAttributes",
          "SNS:DeleteTopic",
          "SNS:ListSubscriptionsByTopic",
          "SNS:GetTopicAttributes",
          "SNS:Receive",
          "SNS:AddPermission",
          "SNS:Subscribe"
        ],
        Resource = [
          "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}"
        ],
        Condition = {
          StringEquals = { "AWS:SourceOwner" = "${data.aws_caller_identity.current.account_id}" }
        }
      },
      {
        Sid    = "allow_bucket_publish-buildroot-ci"
        Effect = "Allow",
        Principal = {
          AWS = ["*"]
        }
        Action = [
          "SNS:Publish",
        ],
        Resource = [
          "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.sns_topic_name}"
        ],
        Condition = {
          ArnLike = { "aws:SourceArn" = "${var.buildroot_ci_bucket_arn}" }
        }
      }

    ]
  })

  delivery_policy = <<EOF
  {
    "http": {
      "defaultHealthyRetryPolicy": {
        "minDelayTarget": 20,
        "maxDelayTarget": 20,
        "numRetries": 3,
        "numMaxDelayRetries": 0,
        "numNoDelayRetries": 0,
        "numMinDelayRetries": 0,
        "backoffFunction": "linear"
      },
      "disableSubscriptionOverrides": false,
      "defaultRequestPolicy": {
        "headerContentType": "text/plain; charset=UTF-8"
      }
    }
  }
  EOF

}

resource "aws_sns_topic_subscription" "s3_slack_update" {
  topic_arn = aws_sns_topic.buildroot_ci_sns_topic.arn
  protocol  = "lambda"
  endpoint  = var.s3_slack_update_lambda_arn
}








output "buildroot_ci_sns_topic_arn" {
  value = aws_sns_topic.buildroot_ci_sns_topic.arn
}