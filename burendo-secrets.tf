resource "github_repository" "burendo_secrets" {
  name        = "burendo-secrets"
  description = "A Private repository holding secrets content stored in AWS Secrets Manager"
  visibility  = "private"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner      = var.github_org
    repository = "burendo-repo-template"
  }
}

resource "github_team_repository" "burendo_secrets_burendo" {
  repository = github_repository.burendo_secrets.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_secrets_admin" {
  repository = github_repository.burendo_secrets.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_secrets_main" {
  pattern        = github_repository.burendo_secrets.default_branch
  repository_id  = github_repository.burendo_secrets.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_secrets" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_secrets.name
}

resource "github_actions_secret" "burendo_secrets_slack_build_notifications_webhook" {
  repository      = github_repository.burendo_handbook.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_build_notifications_webhook
}