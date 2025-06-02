resource "github_repository" "burendo_oddfellows_pt_infra" {
  name        = "burendo-oddfellows-pt-infra"
  description = "Front end repo for the Oddfellows prototype"
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

resource "github_team_repository" "burendo_oddfellows_pt_infra_push" {
  repository = github_repository.burendo_oddfellows_pt_infra.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_oddfellows_pt_infra_admin" {
  repository = github_repository.burendo_oddfellows_pt_infra.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_oddfellows_pt_infra_main" {
  pattern        = github_repository.burendo_oddfellows_pt_infra.default_branch
  repository_id  = github_repository.burendo_oddfellows_pt_infra.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_oddfellows_pt_infra" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_oddfellows_pt_infra.name
}

resource "github_actions_secret" "burendo_oddfellows_pt_infra_github_token" {
  repository      = github_repository.burendo_oddfellows_pt_infra.name
  secret_name     = "GHA_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "burendo_oddfellows_pt_infra_slack_build_notifications_webhook" {
  repository      = github_repository.burendo_oddfellows_pt_infra.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_build_notifications_webhook
}

resource "github_actions_secret" "burendo_oddfellows_pt_infra_slack_engineering_group_id" {
  repository      = github_repository.burendo_oddfellows_pt_infra.name
  secret_name     = "SLACK_ENGINEERING_GROUP_ID"
  plaintext_value = var.gha_aws.slack_engineering_group_id
}
