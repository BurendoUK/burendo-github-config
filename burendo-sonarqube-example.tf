resource "github_repository" "burendo_sonarqube_example" {
  name        = "burendo-sonarqube-example"
  description = "This is a repo to test some sonarqube configuration. After cloning this repo, please run: make bootstrap"
  visibility  = "public"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  is_template = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_team_repository" "burendo_sonarqube_example_burendo" {
  repository = github_repository.burendo_sonarqube_example.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_sonarqube_example_admin" {
  repository = github_repository.burendo_sonarqube_example.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_sonarqube_example_main" {
  pattern        = github_repository.burendo_sonarqube_example.default_branch
  repository_id  = github_repository.burendo_sonarqube_example.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_sonarqube_example" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_sonarqube_example.name
}

resource "github_actions_secret" "burendo_sonarqube_example_terraform_version" {
  repository      = github_repository.burendo_sonarqube_example.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
