terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "<= 3.73.0" # <= https://github.com/hashicorp/terraform-provider-aws/issues/22866
      configuration_aliases = [aws.nwk, aws.domain]
    }
  }
}
