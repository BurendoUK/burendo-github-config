resource "github_repository" "burendo_nhs_dashboard_tooling" {
  name             = "burendo-nhs-dashboard-tooling"
  description      = "Repo to hold the tooling for the NHS Data Dashboard project."
  visibility       = "private"
  auto_init        = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner = var.github_org
    repository = "burendo-repo-template"
  }
}

resource "github_team_repository" "burendo_nhs_dashboard_tooling_push" {
  repository = github_repository.burendo_nhs_dashboard_tooling.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_nhs_dashboard_tooling_admin" {
  repository = github_repository.burendo_nhs_dashboard_tooling.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_nhs_dashboard_tooling_main" {
  pattern        = github_repository.burendo_nhs_dashboard_tooling.default_branch
  repository_id     = github_repository.burendo_nhs_dashboard_tooling.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_nhs_dashboard_tooling" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_nhs_dashboard_tooling.name
}

resource "github_actions_secret" "burendo_nhs_dashboard_tooling_github_token" {
  repository      = github_repository.burendo_nhs_dashboard_tooling.name
  secret_name     = "GHA_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "burendo_nhs_dashboard_tooling_slack_build_notifications_webhook" {
  repository      = github_repository.burendo_nhs_dashboard_tooling.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_build_notifications_webhook
}

resource "github_actions_secret" "burendo_nhs_dashboard_tooling_slack_engineering_group_id" {
  repository      = github_repository.burendo_nhs_dashboard_tooling.name
  secret_name     = "SLACK_ENGINEERING_GROUP_ID"
  plaintext_value = var.gha_aws.slack_engineering_group_id
}
