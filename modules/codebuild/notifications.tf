resource "aws_cloudwatch_event_rule" "builds" {
  name          = "codebuild-to-${aws_sns_topic.builds.name}"
  event_pattern = <<PATTERN
{
    "source": ["aws.codebuild"],
    "detail-type": ["CodeBuild Build State Change"],
    "detail": {
        "build-status": [
            "IN_PROGRESS",
            "SUCCEEDED", 
            "FAILED",
            "STOPPED"
        ]
    }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "builds" {
  target_id = "codebuild-to-${aws_sns_topic.builds.name}"
  rule      = aws_cloudwatch_event_rule.builds.name
  arn       = aws_sns_topic.builds.arn
}

#------------------------------------------------
#
#  Notifications Rules
#
#------------------------------------------------

resource "aws_sns_topic" "builds" {
  name = "${var.environment}-build-notifications"
}

data "aws_iam_policy_document" "notification_access" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [aws_sns_topic.builds.arn]
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.builds.arn
  policy = data.aws_iam_policy_document.notification_access.json
}

resource "aws_codestarnotifications_notification_rule" "builds" {
  depends_on = [ aws_codestarconnections_connection.this ]
  detail_type    = "BASIC"
  event_type_ids = ["codebuild-project-build-state-failed","codebuild-project-build-state-succeeded"]

  name     = "${var.environment}-build-notifications"
  resource = aws_codebuild_project.infra.arn

  target {
    address = aws_sns_topic.builds.arn
  }
}

resource "aws_sns_topic_subscription" "email_notifications" {
  for_each  = toset(["ericpth8@gmail.com"])
  topic_arn = aws_sns_topic.builds.arn
  protocol  = "email"
  endpoint  = each.value
}