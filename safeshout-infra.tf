resource "github_repository" "safeshout_infra" {
  name             = "safeshout-infra"
  description      = "safeshout-infra - Repo for SafeShout Infrastructure - AWS - Terraform "
  visibility       = "private"
  vulnerability_alerts = "false"
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

resource "github_team_repository" "safeshout_infra_burendo" {
  repository = github_repository.safeshout_infra.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "safeshout_infra_admin" {
  repository = github_repository.safeshout_infra.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "safeshout_infra_main" {
  pattern        = github_repository.safeshout_infra.default_branch
  repository_id     = github_repository.safeshout_infra.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "safeshout_infra" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.safeshout_infra.name
}
