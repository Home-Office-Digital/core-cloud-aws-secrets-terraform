provider "aws" {
  access_key                  = "mock"
  region                      = "eu-west-2"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}

variables {
  aws_account_id     = "123456789012"
  aws_account_region = "eu-west-2"
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

run "plan_kms_key_rotation_is_enabled" {
  command = plan

  assert {
    condition     = aws_kms_key.secrets.enable_key_rotation
    error_message = "KMS key rotation must be enabled."
  }
}
