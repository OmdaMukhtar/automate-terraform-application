variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
  default     = "my-organization/example"
}

variable "github_branch" {
  description = "GitHub branch to use"
  type        = string
  default     = "main"
}

variable "buildspec_file" {
  description = "Path to buildspec file"
  type        = string
  default     = "buildspec.yml"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}