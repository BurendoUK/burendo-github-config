resource "github_repository" "bad_community_toolkit" {
  name        = "bad-community-toolkit"
  description = "bad-community-toolkit"
  visibility  = "public"
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

resource "github_team_repository" "bad_community_toolkit_burendo" {
  repository = github_repository.bad_community_toolkit.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "bad_community_toolkit_admin" {
  repository = github_repository.bad_community_toolkit.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "bad_community_toolkit_main" {
  pattern        = github_repository.bad_community_toolkit.default_branch
  repository_id  = github_repository.bad_community_toolkit.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "bad_community_toolkit" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.bad_community_toolkit.name
}
