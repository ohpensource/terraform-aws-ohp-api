terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.6"
      configuration_aliases = [aws.nwk, aws.domain]
    }
  }
}
