resource "github_repository" "azuredevops_demo" {
  name        = "azuredevops-demo"
  description = "Repo containing the Azure DevOps Demo"
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

resource "github_team_repository" "azuredevops_demo_burendo" {
  repository = github_repository.azuredevops_demo.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "azuredevops_demo_admin" {
  repository = github_repository.azuredevops_demo.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "azuredevops_demo_main" {
  pattern        = github_repository.azuredevops_demo.default_branch
  repository_id  = github_repository.azuredevops_demo.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "azuredevops_demo" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.azuredevops_demo.name
}

resource "github_actions_secret" "azuredevops_demo_terraform_version" {
  repository      = github_repository.azuredevops_demo.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
