variable "github_url" {
  description = "Github repository project"
  type        = string
  default     = "https://github.com/OmdaMukhtar/automate-terraform-application.git"
}

variable "buildspec_file" {
  description = "Buildspec file of the codebuild"
  type        = string
  default     = "buildspec.yml"
}