provider "aws" {
  region = "ap-northeast-1"
}

resource "random_id" "project_suffx" {
  byte_length = 4
}

# Create CodeBuild Project
resource "aws_codebuild_project" "web_deployer" {
  name         = "deploy-dev-infrastructure-oop-${random_id.project_suffx.hex}"
  service_role = aws_iam_role.codebuild_role.arn
  

  artifacts {
    type = "CODEPIPELINE"
  }

  build_timeout = 30

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "app-terraform/buildspec.yml"
  }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-web-deployer-role-${random_id.project_suffx.hex}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attached  the policy to codebuild role
resource "aws_iam_role_policy" "codebuild_policy" {
  role   = aws_iam_role.codebuild_role.name
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

  # allow terraform to manage infrastructure
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

  # allow creating roles and tagging them
  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:PutRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:CreateRole",
      "iam:PassRole",
      "iam:TagRole",
      "iam:AttachRolePolicy"
    ]
    resources = ["*"]
  }

  # allow creating codestar connections and tagging them
  statement {
    effect = "Allow"
    actions = [
      "codeconnections:GetConnection",
      "codeconnections:CreateConnection",
      "codeconnections:TagResource",
      "codeconnections:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateProject",
      "codebuild:BatchGetProjects",
      "codebuild:ListProjects"
    ]
    resources = ["*"]
  }
}
