locals {
  tags = {
    Project = "infra-CI/CD-demo"
    CreatedBy = "Omda"
    IssueDate = timestamp()
    Environment = "dev"
  }
}
module "codebuild" {
  source = "./module/codebuild"
}

module "codepipeline" {
  source = "./module/codepipeline"
  codebuild_project_name = module.codebuild.codebuild_project_name
}