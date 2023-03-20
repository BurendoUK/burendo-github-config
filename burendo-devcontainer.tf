resource "github_repository" "burendo_devcontainer" {
  name        = "burendo-devcontainer"
  description = "Repo for the Burendo VSCode Devcontainer.  This devcontainer is used for all Burendo projects."
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

resource "github_team_repository" "burendo_devcontainer_burendo" {
  repository = github_repository.burendo_devcontainer.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_devcontainer_admin" {
  repository = github_repository.burendo_devcontainer.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_devcontainer_main" {
  pattern        = github_repository.burendo_devcontainer.default_branch
  repository_id  = github_repository.burendo_devcontainer.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_devcontainer" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_devcontainer.name
}
