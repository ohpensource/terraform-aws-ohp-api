resource "aws_api_gateway_base_path_mapping" "main" {
  provider = aws.nwk

  api_id      = aws_api_gateway_rest_api.main.id
  base_path   = var.api_base_path
  stage_name  = var.stage_name
  domain_name = var.domain_name

  depends_on = [
    aws_api_gateway_stage.main
  ]
}

