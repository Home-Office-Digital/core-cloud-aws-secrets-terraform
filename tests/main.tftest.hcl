mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
      arn        = "arn:aws:iam::123456789012:root"
      user_id    = "123456789012"
    }
  }

  mock_data "aws_region" {
    defaults = {
      name = "eu-west-2"
    }
  }

  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

variables {
  aws_secrets = {
    "test-secret" = {
      secret_description    = "Test secret"
      session_name_to_allow = "github-actions"
      iam_roles             = []
      tags = {
        account-code     = "123456"
        cost-centre      = "9999"
        service-id       = "test"
        portfolio-id     = "test"
        project-id       = "cc"
        owner-business   = "test-team"
        budget-holder    = "test@example.com"
        environment-type = "test"
        source-repo      = "test-repo"
      }
    }
  }
}

run "kms_key_rotation_is_enabled" {
  command = plan

  assert {
    condition     = module.secret_and_role["test-secret"].kms_key_rotation_enabled == true
    error_message = "KMS key rotation must be enabled"
  }
}
