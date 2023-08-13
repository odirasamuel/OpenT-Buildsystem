data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#Buildroot CI Bucket
resource "aws_s3_bucket" "buildroot_ci" {
  bucket = "${var.codebuild_project_name}-ci"

  tags = {
    Name = "${var.codebuild_project_name}-ci"
  }
}

#Buildroot CI bucket versioning
resource "aws_s3_bucket_versioning" "buildroot_ci" {
  bucket = aws_s3_bucket.buildroot_ci.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Buildroot CI bucket publish to SNS
resource "aws_s3_bucket_notification" "publish_to_sns" {
  bucket = aws_s3_bucket.buildroot_ci.id

  topic {
    topic_arn = var.buildroot_ci_sns_topic_arn
    events    = ["s3:ObjectCreated:*"]
  }
}

#Buildroot build caching bucket
resource "aws_s3_bucket" "buildroot_build_caching" {
  bucket = var.buildroot_caching_bucket

  tags = {
    Name = "${var.buildroot_caching_bucket}"
  }
}

#Block public access from buildroot build caching bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.buildroot_build_caching.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#CodeBuild
resource "aws_codebuild_project" "opentrons_buildroot" {
  name           = var.codebuild_project_name
  description    = "Builder for the Opentrons system"
  build_timeout  = "120"
  service_role   = aws_iam_role.codebuild_service_role.arn
  encryption_key = aws_kms_key.artifacts_kms_key.arn

  artifacts {
    type                = "S3"
    encryption_disabled = true
    location            = aws_s3_bucket.buildroot_ci.bucket
    namespace_type      = "BUILD_ID"
    name                = var.codebuild_project_name
    bucket_owner_access = "FULL"
    packaging           = "NONE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.buildroot_build_caching.bucket
  }

  environment {
    image           = var.image
    type            = var.build_env
    compute_type    = var.build_compute_type
    privileged_mode = true
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED"
      group_name  = aws_cloudwatch_log_group.build_log_group.name
      stream_name = aws_cloudwatch_log_stream.build_log_stream.name
    }
  }

  source {
    type            = "GITHUB"
    git_clone_depth = 5
    location        = var.main_source_url
  }

  secondary_sources {
    source_identifier = var.secondary_source_identifier
    type              = "GITHUB"
    git_clone_depth   = 5
    location          = var.secondary_source_url
  }

  tags = {
    "Name" = "${var.codebuild_project_name}"
  }
}


data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

#Codebuild service role
resource "aws_iam_role" "codebuild_service_role" {
  name               = "${var.codebuild_project_name}-codebuild-service-role"
  description        = "IAM role that permissions to codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

#Permission to access SSM parameters
resource "aws_iam_role_policy" "ssm_parameters" {
  name = "${var.codebuild_project_name}-codebuild-list-ssm-params"
  role = aws_iam_role.codebuild_service_role.name
  policy = templatefile("./modules/policies/codebuild_ssm.json", {
    parameters_arn = "arn:aws:ssm:*:*:parameter/*"
  })
}

#Permissions to access the buildroot
resource "aws_iam_role_policy" "codebuild_base_policy_buildroot" {
  name = "CodeBuildBasePolicy-${var.codebuild_project_name}"
  role = aws_iam_role.codebuild_service_role.name
  policy = templatefile("./modules/policies/codebuild_buildroot.json", {
    codebuild_project_log_group_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}",
    codepipeline_arn                = "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-*",
    buildroot_ci_arn                = "arn:aws:s3:::${var.codebuild_project_name}-ci",
    codebuild_report_group_arn      = "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/${var.codebuild_project_name}-*"
  })
}

#Permission to write to opentrons buildroot cloudwatch log group
resource "aws_iam_role_policy" "codebuild_cloudwatch_logs_policy_buildroot" {
  name = "CodeBuildCloudWatchLogsPolicy-${var.codebuild_project_name}"
  role = aws_iam_role.codebuild_service_role.name
  policy = templatefile("./modules/policies/codebuild_cloudwatch_buildroot.json", {
    build_log_group_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:build"
  })
}

#Permission to access buildroot cache bucket
resource "aws_iam_role_policy" "codebuild_cache_policy_buildroot" {
  name = "CodeBuildCachePolicy-${var.codebuild_project_name}"
  role = aws_iam_role.codebuild_service_role.name
  policy = templatefile("./modules/policies/codebuild_cache_buildroot.json", {
    build_cache_arn = "arn:aws:s3:::${var.buildroot_caching_bucket}"
  })
}

#AWS managed KMS key for codebuild artifacts
resource "aws_kms_key" "artifacts_kms_key" {
  description             = "Key that protects S3 objects"
  deletion_window_in_days = 7
}

#AWS managed KMS key alias
resource "aws_kms_alias" "artifacts_kms_key_alias" {
  # name          = "alias/aws/s3"
  target_key_id = aws_kms_key.artifacts_kms_key.key_id
}

#Cloudwatch log group for builds
resource "aws_cloudwatch_log_group" "build_log_group" {
  name              = var.build_log_group_name
  retention_in_days = 0

  tags = {
    Name        = "${var.build_log_group_name}"
    Instance    = var.instance
    Environment = var.env
  }
}

#Cloudwatch log stream for builds
resource "aws_cloudwatch_log_stream" "build_log_stream" {
  name           = var.build_log_stream_name
  log_group_name = aws_cloudwatch_log_group.build_log_group.name
}

#Cloudwatch log group for codebuild project
resource "aws_cloudwatch_log_group" "codebuild_project_log_group" {
  name              = "/aws/codebuild/${var.codebuild_project_name}"
  retention_in_days = 0

  tags = {
    Name = "${var.codebuild_project_name}"
  }
}

#CodeBuild source credentials
resource "aws_codebuild_source_credential" "source_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.source_token
}





output "buildroot_ci_bucket_arn" {
  value = aws_s3_bucket.buildroot_ci.arn
}

output "buildroot_build_caching_bucket_arn" {
  value = aws_s3_bucket.buildroot_build_caching.arn
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.opentrons_buildroot.arn
}