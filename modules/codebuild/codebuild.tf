
resource "aws_s3_bucket" "cache" {
  bucket = "${var.environment}-cache"
}

resource "aws_codebuild_project" "infra" {
  
  name                   = "infra-${var.environment}"
  description            = "Code build Project for ${var.environment} Infrastructure"
  source_version         = var.source_version
  service_role           = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

   cache {
    type     = "S3"
    location = aws_s3_bucket.cache.bucket
  }
  
  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_credentials_type

    environment_variable {
      name  = "ENVIRONMENT"
      type  = "PLAINTEXT"
      value = var.environment
    }

  }

  source {

    buildspec           = var.buildspec
    type                = var.source_type
    location            = var.location
    report_build_status = false
    insecure_ssl        = false
    git_clone_depth     = 0

    git_submodules_config {
              fetch_submodules = true
    }
  }

 logs_config {
    
    cloudwatch_logs {
        
        group_name = "codebuild-${var.environment}"
        status     = "ENABLED"
    }
        
    s3_logs {
        
        encryption_disabled = false 
        status              = "DISABLED" 
    }
 }

}

#------------------------------------------------------------
#
# Role Definition for Code Build Project
#
#-------------------------------------------------------------

data "aws_iam_policy_document" "codebuild_project_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild-role" {
  name               = "codebuild-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_project_assume_role.json
}

data "aws_iam_policy_document" "codebuild-project-policy-document" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::codepipeline-us-east-1-*"]
    
    }

    statement {
    effect  = "Allow"
    actions = [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
    ]
    resources = [
         "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:codebuild-${var.environment}",
         "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:codebuild-${var.environment}:*"
    ]
    
    }
    
    statement {
    effect  = "Allow"
    actions = [
       "codebuild:CreateReportGroup",
       "codebuild:CreateReport",
       "codebuild:UpdateReport",
       "codebuild:BatchPutTestCases",
       "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
         "arn:aws:codebuild:${var.aws_region}:${var.aws_account}:report-group/${aws_codebuild_project.infra.name}-*"
    ]
    
    }

}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  name   = "codebuild-policy-${var.environment}" 
  role   = aws_iam_role.codebuild-role.name
  policy = data.aws_iam_policy_document.codebuild-project-policy-document.json
}

#----------------------------------------------------
#
#  CodeBuild Role AWS Connection Permissions 
#
#----------------------------------------------------

data "aws_iam_policy_document" "codebuild-role-codepipeline-policy-document" {
  statement {
    effect = "Allow"
    actions = ["codestar-connections:UseConnection"]
    resources = ["${aws_codestarconnections_connection.this.arn}"]
  }
}

resource "aws_iam_role_policy" "codebuild-role-codepipeline-policy" {
  name   = "codepipeline-permissions-policy-${var.environment}" 
  role   = aws_iam_role.codebuild-role.name
  policy = data.aws_iam_policy_document.codebuild-role-codepipeline-policy-document.json
}


