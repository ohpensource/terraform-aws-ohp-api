# Why a root module? -> https://github.com/hashicorp/terraform/issues/28490

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

provider "aws" {
  alias  = "nwk"
  region = var.aws_region
}

provider "aws" {
  alias  = "domain"
  region = var.aws_region
}

module "main" {
  source = "../../module"

  providers = {
    aws.nwk    = aws.nwk
    aws.domain = aws.domain
  }

  # THIS EXAMPLE CREATES AN API WITH THE FOLLOWING ENDPOINTS
  # GET    api.example.ohpen.com/accounts/ping
  # POST   api.example.ohpen.com/accounts
  # DELETE api.example.ohpen.com/accounts/{id}
  # GET    api.example.ohpen.com/accounts/{id}
  # PUT    api.example.ohpen.com/accounts/{id}

  stage_name             = "dev"
  aws_nwk_account_id     = "485927592879271"
  aws_region             = "eu-west-1"
  cognito_user_pool_name = "name-of-my-cognito-user-pool"
  web_acl_name           = "name-of-my-web-acl"
  domain_name            = "api.example.ohpen.com"
  api_name               = "awesome-api-ohpen-dev"
  api_version            = "1.2.3"
  api_base_path          = "accounts"

  endpoints = {
    "GET /ping" = {
      integration_type = "LAMBDA"
      configuration = {
        lambda_function_name = "name-of-my-lambda"
      }
      allowed_authorization_scopes = [
        "name-of-monitoring-scope"
      ]
    }
    "POST /" = {
      integration_type = "LAMBDA"
      configuration = {
        lambda_function_name = "name-of-my-lambda"
      }
      allowed_authorization_scopes = [
        "name-of-write-scope"
      ]
    }
    "DELETE /{id}" = {
      integration_type = "LAMBDA"
      configuration = {
        lambda_function_name = "name-of-my-lambda"
      }
      allowed_authorization_scopes = [
        "name-of-admin-scope"
      ]
    }
    "GET /{id}" = {
      integration_type = "LAMBDA"
      configuration = {
        lambda_function_name = "name-of-my-lambda"
      }
      allowed_authorization_scopes = [
        "name-of-reader-scope"
      ]
    }
    "PUT /{id}" = {
      integration_type = "LAMBDA"
      configuration = {
        lambda_function_name = "name-of-my-lambda"
      }
      allowed_authorization_scopes = [
        "name-of-writer-scope"
      ]
    }
  }
}
