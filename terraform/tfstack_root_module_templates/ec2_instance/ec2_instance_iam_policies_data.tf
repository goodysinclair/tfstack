## add 'statements' with incremental sid values here
## for additional IAM permissions:
data "aws_iam_policy_document" "policy" {
  statement {
    sid = "1"

    effect = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
    actions = [
      "logs:DescribeLogStreams"
    ]
  }
}

## modify if needed:
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

