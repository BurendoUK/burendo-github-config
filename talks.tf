resource "github_repository" "talks" {
  name        = "talks"
  description = "Supporting materials for conference and event talks given by the Burendo team"
  visibility  = "public"
  auto_init   = false

  allow_merge_commit     = true
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

resource "github_team_repository" "talks_burendo" {
  repository = github_repository.talks.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "talks_admin" {
  repository = github_repository.talks.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "talks_main" {
  pattern        = github_repository.talks.default_branch
  repository_id  = github_repository.talks.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "talks" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.talks.name
}
