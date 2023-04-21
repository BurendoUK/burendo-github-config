resource "github_repository" "burendo_github_config" {
  name        = "burendo-github-config"
  description = "IAC repository of all GitHub repositories in this Org"
  visibility  = "public"
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

resource "github_team_repository" "burendo_github_config_burendo" {
  repository = github_repository.burendo_github_config.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_github_config_admin" {
  repository = github_repository.burendo_github_config.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_github_config_main" {
  pattern        = github_repository.burendo_github_config.default_branch
  repository_id  = github_repository.burendo_github_config.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_github_config" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_github_config.name
}

resource "github_actions_secret" "aws_access_key_id_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "ACTIONS_ACCESS_KEY_ID"
  plaintext_value = var.gha_aws.access_key_id
}

resource "github_actions_secret" "aws_secret_access_key_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "ACTIONS_SECRET_ACCESS_KEY"
  plaintext_value = var.gha_aws.secret_access_key
}

resource "github_actions_secret" "aws_role_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "AWS_GHA_ROLE"
  plaintext_value = "arn:aws:iam::${local.account["burendo-prod"]}:role/ci"
}

resource "github_actions_secret" "aws_terraform_version_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}

resource "github_actions_secret" "aws_acc_prod_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "AWS_GHA_ACC_PROD"
  plaintext_value = local.account["burendo-prod"]
}

resource "github_actions_secret" "slack_build_notifications_webhook_burendo_github_config" {
  repository      = github_repository.burendo_github_config.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.slack_build_notifications_webhook
}
