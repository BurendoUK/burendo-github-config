resource "github_repository" "safeshout_frontend" {
  name             = "safeshout-frontend"
  description      = "safeshout-frontend - Repo for SafeShout frontend"
  visibility       = "private"
  vulnerability_alerts = "false"
  auto_init        = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = concat(local.common_topics, local.aws_topics)

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner = var.github_org
    repository = "burendo-repo-template"
  }
}

resource "github_team_repository" "safeshout_frontend_burendo" {
  repository = github_repository.safeshout_frontend.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "safeshout_frontend_admin" {
  repository = github_repository.safeshout_frontend.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "safeshout_frontend_main" {
  pattern        = github_repository.safeshout_frontend.default_branch
  repository_id     = github_repository.safeshout_frontend.name
  enforce_admins = true

  required_status_checks {
    strict = true
    contexts = [
      "Check Amplify Build Status", "Claude Code Review"
    ]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "safeshout_frontend" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.safeshout_frontend.name
}

resource "github_actions_secret" "aws_dev_role_safeshout_frontend_gha_role_dev" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "AWS_GHA_ROLE_SAFESHOUT_DEV"
  plaintext_value = "arn:aws:iam::${local.account["safeshout-dev"]}:role/SafeshoutCI"
}

resource "github_actions_secret" "aws_dev_role_safeshout_frontend_gha_role_mgmt" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "AWS_GHA_ROLE_SAFESHOUT_MGMT"
  plaintext_value = "arn:aws:iam::${local.account["safeshout-mgmt"]}:role/SafeshoutCI"
}

resource "github_actions_secret" "aws_dev_role_safeshout_frontend_gha_role_staging" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "AWS_GHA_ROLE_SAFESHOUT_STAGING"
  plaintext_value = "arn:aws:iam::${local.account["safeshout-staging"]}:role/SafeshoutCI"
}

resource "github_actions_secret" "aws_safeshout_mgmt_access_key_id_safeshout_frontend" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "ACTIONS_SAFESHOUT_MGMT_ACCESS_KEY_ID"
  plaintext_value = var.gha_aws.safeshout_mgmt_access_key_id
}

resource "github_actions_secret" "aws_safeshout_mgmt_secret_access_key_safeshout_frontend" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "ACTIONS_SAFESHOUT_MGMT_SECRET_ACCESS_KEY"
  plaintext_value = var.gha_aws.safeshout_mgmt_secret_access_key
}

resource "github_actions_secret" "slack_safeshout_webhook_safeshout_frontend" {
  repository      = github_repository.safeshout_frontend.name
  secret_name     = "SLACK_SAFESHOUT_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_safeshout_build_notifications_webhook
}
