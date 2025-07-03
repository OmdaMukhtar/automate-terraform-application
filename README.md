# CI/CD Terraform using Codebuild and CodePipeline

## Requirements

- change configuration on codebuild 
```
  artifacts {
    type = "NO_ARTIFACTS"
  }
```

TO

```
 artifacts {
    type = "CODEPIPELINE"
  }
```