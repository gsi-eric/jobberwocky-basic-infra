
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.environment}-codepipeline-artifacts"
}

resource "aws_codestarconnections_connection" "this" {
  name          = "${var.environment}"
  provider_type = "${var.source_type}"
}

resource "aws_codepipeline" "CodePipeline" {
    name = "infra-${var.environment}-codepipeline"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
        location = aws_s3_bucket.codepipeline_bucket.bucket
        type = "S3"
    }
    stage {
        name = "Source"
        action {
                name = "Source"
                category = "Source"
                owner = "AWS"
                provider = "CodeStarSourceConnection"
                version = "1"
                output_artifacts = ["SourceArtifact"]
                run_order = 1

        configuration = {
                    BranchName = var.source_version
                    ConnectionArn = "${aws_codestarconnections_connection.this.arn}"
                    DetectChanges = "true"
                    FullRepositoryId = var.full_repository_id
                    OutputArtifactFormat = "CODE_ZIP"
                }
        }
    }

    stage {
        name = "Build"
        action{
            name = "Build"
            category = "Build"
            owner = "AWS"
            input_artifacts = ["SourceArtifact"]
            provider = "CodeBuild"
            version = "1"
            output_artifacts = ["BuildArtifact"]
            run_order = 1
            namespace = "SourceRepository"

        configuration = {
                    ProjectName = "${aws_codebuild_project.infra.name}"
                    "EnvironmentVariables" = jsonencode(
                        [
                          {
                            name  = "CODESOURCE_BRANCH"
                            type  = "PLAINTEXT"
                            value = "#{SourceRepository.BranchName}"
                          },
                          {
                            name  = "COMMIT_ID"
                            type  = "PLAINTEXT"
                            value = "#{SourceRepository.CommitId}"
                          },
                        ]
                    ) 
                }
        }
            
    }
}


#-----------------------------------------------
#
#       Role definition for Codepipeline
#
#------------------------------------------------

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
  name               = "${var.environment}-codepipeline-role"
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
    resources = ["${aws_codestarconnections_connection.this.arn}"]
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
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

