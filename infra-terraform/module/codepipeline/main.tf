provider "aws" {
  alias  = "codestar"
  region = "ap-northeast-1"
}

resource "random_id" "project_suffx" {
  byte_length = 4
}

resource "aws_codepipeline" "codepipeline" {
  name     = "demo-terraform-pipeline-deployer-${random_id.project_suffx.hex}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "PullProject"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = "OmdaMukhtar/automate-terraform-application"
        BranchName       = "master"
      }
    }
  }

  stage {
    name = "TerraformApply"

    action {
      name             = "BuildAndDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}

resource "aws_codestarconnections_connection" "github_connection" {
  name          = "github-connection-${random_id.project_suffx.hex}"
  provider_type = "GitHub"
  provider      = aws.codestar
   lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "pipline-bucket-oop-${random_id.project_suffx.hex}"
  force_destroy = true
  provider      = aws.codestar
}
resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "pipline-role-${random_id.project_suffx.hex}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github_connection.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy-${random_id.project_suffx.hex}"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

# Automatically delete the connection on destroy
# resource "null_resource" "delete_codestar_connection" {
#   triggers = {
#     connection_arn = aws_codestarconnections_connection.github_connection.arn
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = "aws codestar-connections delete-connection --connection-arn ${self.triggers.connection_arn}"
#   }
# }