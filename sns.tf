resource "aws_sns_topic" "scaling_sns" {
  name         = join("-", [var.application, var.env, "event-sns"])
  display_name = join("-", [var.application, var.env, "event-sns"])
  tags         = var.tags
}

resource "aws_sns_topic_subscription" "scaling_sns_lambda_subscription" {
  topic_arn = aws_sns_topic.scaling_sns.arn
  protocol  = "lambda"
  endpoint  = var.scaling-lambda-arn
}

resource "aws_sns_topic_policy" "scaling_sns_policy" {
  arn    = aws_sns_topic.scaling_sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = [
      "sns:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.scaling_sns.arn,
    ]
  }
}