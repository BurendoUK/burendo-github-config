resource "github_repository" "burendo_identity" {
  name        = "burendo-identity"
  description = "Burendo user identity management for AWS"
  visibility  = "private"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = concat(local.common_topics, local.aws_topics)

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner      = var.github_org
    repository = "burendo-repo-template-terraform"
  }
}

resource "github_team_repository" "burendo_identity_burendo" {
  repository = github_repository.burendo_identity.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_identity_admin" {
  repository = github_repository.burendo_identity.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_identity_main" {
  pattern        = github_repository.burendo_identity.default_branch
  repository_id  = github_repository.burendo_identity.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_identity" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_identity.name
}

resource "github_actions_secret" "aws_terraform_version_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}

resource "github_actions_secret" "aws_secret_access_key_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "ACTIONS_SECRET_ACCESS_KEY"
  plaintext_value = var.gha_aws.secret_access_key
}

resource "github_actions_secret" "aws_prod_role_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "AWS_GHA_ROLE_PROD"
  plaintext_value = "arn:aws:iam::${local.account["burendo-prod"]}:role/ci"
}

resource "github_actions_secret" "aws_acc_prod_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "AWS_GHA_ACC_PROD"
  plaintext_value = local.account["burendo-prod"]
}

resource "github_actions_secret" "aws_mgmt_role_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "AWS_GHA_ROLE_MGMT"
  plaintext_value = "arn:aws:iam::${local.account["burendo-mgmt"]}:role/ci"
}

resource "github_actions_secret" "aws_acc_mgmt_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "AWS_GHA_ACC_MGMT"
  plaintext_value = local.account["burendo-mgmt"]
}

resource "github_actions_secret" "slack_build_notifications_webhook_burendo_identity" {
  repository      = github_repository.burendo_identity.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.slack_build_notifications_webhook
}
