data "aws_iam_policy_document" "main_policy" {
  statement {
    sid       = "ApiPolicy"
    effect    = "Allow"
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]

    }
  }
}

data "aws_iam_policy_document" "cw_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.apigw_access_logs.arn,
      aws_cloudwatch_log_group.apigw_exec_logs.arn
    ]
  }
}

resource "aws_api_gateway_rest_api_policy" "main" {
  provider = aws.nwk

  rest_api_id = aws_api_gateway_rest_api.main.id
  policy      = data.aws_iam_policy_document.main_policy.json
}

resource "aws_iam_role" "main" {
  provider = aws.nwk

  name               = var.api_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "cloudwatch" {
  provider = aws.nwk

  name   = var.api_name
  role   = aws_iam_role.main.id
  policy = data.aws_iam_policy_document.cw_policy.json
}
