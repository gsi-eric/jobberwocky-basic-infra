
variable "environment" {
    type = string
    description = "Environment for the CodeBuild Project"
}

variable "aws_region" {
  type = string
  description = "Region for your resources to be deployed"
  default = "us-east-1"
}

variable "aws_account" {
  type = string
  description = "AWS Account for your resources to be deployed"
}

#------------------------------------------
#
#  CodeBuild Project Variables
#
#------------------------------------------

variable "description" {
  description = "The description of the codebuild project"
  type        = string
  default     = null
}

variable "build_timeout" {
  description = "The timeout of the codebuild project"
  type        = string
  default     = "15"
}

variable "artifacts_type" {
  description = "The artifacts type of the codebuild project"
  type        = string
  default     = "NO_ARTIFACTS"
}

variable "source_type" {
  description = "the source type of the codebuild project"
  type        = string
}

variable "source_buildspec" {
  description = "The buildspec of the codebuild project"
  type        = string
}

variable "environment_type" {
  description = "The environment type of the codebuild project"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "environment_compute_type" {
  description = "The environment compute type of the codebuild project"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "environment_image" {
  description = "The environment image of the codebuild project"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "privileged_mode" {
  description = "The privileged mode of the codebuild project"
  type        = string
  default     = false
}

variable "environment_variable" {
  description = "Environment variable"
  type        = map(string)
  default     = {}
}

variable "location" {
    type = string
    description = "The URL for the repo project for the codebuild project"
}

variable "buildspec" {
  type = string
  description = "Location of the buildspec for the codebuild project"
}

variable "compute_type" {
  type = string
  description = "Compute Type for the codebuild project"
}

variable "image" {
  type = string
  description = "Image for the codebuild project"
}

variable "type" {
  type = string
  description = "Image type for the codebuild project"
}

variable "image_pull_credentials_type" {

  type = string
  description = "Image pull credentials type for the codebuild project"
  
}

variable "source_version" {
  type = string
  description = "Branch for the codebuild project"
}

#----------------------------------------
# 
#  CodePipeline Variables
#
#----------------------------------------

variable "full_repository_id" {
  type = string
  description = "Id of the repository"
}

variable "git_url" {
  type = string
  description = "The url of the repository"
}

variable "codesource_branch"{
  type = string
  description = "The branch of the repository"
}