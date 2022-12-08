resource "github_repository" "stackedit" {
  name        = "stackedit"
  description = "In-browser Markdown editor"
  visibility  = "public"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_team_repository" "stackedit_burendo" {
  repository = github_repository.stackedit.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "stackedit_admin" {
  repository = github_repository.stackedit.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "stackedit_main" {
  pattern        = github_repository.stackedit.default_branch
  repository_id  = github_repository.stackedit.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "stackedit" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.stackedit.name
}