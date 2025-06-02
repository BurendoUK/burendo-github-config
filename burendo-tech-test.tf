resource "github_repository" "burendo_tech_test" {
  name             = "burendo-tech-test"
  description      = "Repo to hold the engineering tech test for Burendo"
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

resource "github_team_repository" "burendo_tech_test_push" {
  repository = github_repository.burendo_tech_test.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_tech_test_admin" {
  repository = github_repository.burendo_tech_test.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_tech_test_main" {
  pattern        = github_repository.burendo_tech_test.default_branch
  repository_id     = github_repository.burendo_tech_test.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_tech_test" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_tech_test.name
}

resource "github_actions_secret" "burendo_tech_test_github_token" {
  repository      = github_repository.burendo_tech_test.name
  secret_name     = "GHA_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "burendo_tech_test_slack_build_notifications_webhook" {
  repository      = github_repository.burendo_tech_test.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_build_notifications_webhook
}

resource "github_actions_secret" "burendo_tech_test_slack_engineering_group_id" {
  repository      = github_repository.burendo_tech_test.name
  secret_name     = "SLACK_ENGINEERING_GROUP_ID"
  plaintext_value = var.gha_aws.slack_engineering_group_id
}
