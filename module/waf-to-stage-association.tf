data "aws_wafv2_web_acl" "main" {
  provider = aws.nwk

  count = var.web_acl_name != null ? 1 : 0

  name  = var.web_acl_name
  scope = var.web_acl_scope
}

resource "aws_wafv2_web_acl_association" "main" {
  provider = aws.nwk

  count = var.web_acl_name != null ? 1 : 0

  resource_arn = aws_api_gateway_stage.main.arn
  web_acl_arn  = data.aws_wafv2_web_acl.main[0].arn
}
