# Create CodeBuild Project
resource "aws_codebuild_project" "web_deployer" {
  name         = "deploy-dev-infrastructure"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  build_timeout = 5

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true 
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
  }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-web-deployer-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attached  the policy to codebuild role
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name
  policy = data.aws_iam_policy_document.permissions.json
}

data "aws_iam_policy_document" "permissions" {
  # logs 
  statement {
    effect = "Allow"

    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  # infra terraform backend
  statement {
    effect = "Allow"

    actions = [
        "ec2:*",
        "s3:*",
        "dynamodb:*",
        "kms:*"
    ]

    resources = ["*"]
  }

}
