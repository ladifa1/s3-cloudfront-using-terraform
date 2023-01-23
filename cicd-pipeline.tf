# Setup your build environment
resource "aws_codebuild_project" "build_app" {
  name          = "build-app"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_SOURCE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.example.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git" # Specify repo you are using
    buildspec       = "arn:aws:s3:::<bucket>/buildspec.yml"
  }

  source_version = "master"

}


resource "aws_codepipeline" "codepipeline" {
  name     = "codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.network.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "my-organization/example"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_app.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"
      RunOrder = "1"
      Region = "var.region"

      configuration = {
        BucketName = var.bucket_network
        Extract = "true"
        ObjectKey = ""
      }
    }
  }
}