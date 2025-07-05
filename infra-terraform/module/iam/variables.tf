variable "codepipeline_bucket_arn" {
  description = "ARN of the CodePipeline S3 bucket"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection"
  type        = string
}

variable "codebuild_project_arns" {
  description = "List of ARNs of CodeBuild projects"
  type        = list(string)
}