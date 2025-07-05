variable "github_oauth_token" {
  type    = string
  default = ""
}

variable "branch_name" {
  type    = string
  default = "master"
}

variable "codebuild_project_name" {
  type        = string
  description = "The CodeBuild project name."
  validation {
    condition     = length(var.codebuild_project_name) > 0
    error_message = "The CodeBuild project name must not be empty."
  }
}