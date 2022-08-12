resource "github_repository" "burendo_githooks" {
  name        = "burendo-githooks"
  description = "Default Git hooks for Burendo repositories"
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

resource "github_team_repository" "burendo_githooks_burendo" {
  repository = github_repository.burendo_githooks.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_githooks_admin" {
  repository = github_repository.burendo_githooks.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_githooks_main" {
  pattern        = github_repository.burendo_githooks.default_branch
  repository_id  = github_repository.burendo_githooks.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_githooks" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_githooks.name
}

resource "null_resource" "burendo_githooks" {
  triggers = {
    repo = github_repository.burendo_githooks.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_githooks.name} '${github_repository.burendo_githooks.description}' ${github_repository.burendo_githooks.template.0.repository}"
  }
}

resource "github_actions_secret" "burendo_githooks_terraform_version" {
  repository      = github_repository.burendo_githooks.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
