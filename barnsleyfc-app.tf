resource "github_repository" "barnsleyfc_app" {
  name             = "barnsleyfc-app"
  description      = "barnsleyfc-app - Repo for Barsley FC app "
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
    repository = "burendo-repo-template-terraform"
  }
}

resource "github_team_repository" "barnsleyfc_app_burendo" {
  repository = github_repository.barnsleyfc_app.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "barnsleyfc_app_admin" {
  repository = github_repository.barnsleyfc_app.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "barnsleyfc_app_main" {
  pattern        = github_repository.barnsleyfc_app.default_branch
  repository_id     = github_repository.barnsleyfc_app.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "barnsleyfc_app" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.barnsleyfc_app.name
}
