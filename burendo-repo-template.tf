resource "github_repository" "burendo_repo_template" {
  name        = "burendo-repo-template"
  description = "This repo contains Makefile to fit the standard pattern. This repo is a base to create new non-Terraform repos, adding the githooks submodule, making the repo ready for use. After cloning this repo, please run: make bootstrap"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner      = var.github_organization
    repository = "burendo-repo-template"
  }
}

resource "github_team_repository" "burendo_repo_template_burendo" {
  repository = github_repository.burendo_repo_template.name
  permission = "push"
}

resource "github_team_repository" "burendo_repo_template-admin" {
  repository = github_repository.burendo_repo_template.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_repo_template_master" {
  branch         = github_repository.burendo_repo_template.default_branch
  repository     = github_repository.burendo_repo_template.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_repo_template" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_repo_template.name
}

resource "null_resource" "burendo_repo_template" {
  triggers = {
    repo = github_repository.burendo_repo_template.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_repo_template.name} '${github_repository.burendo_repo_template.description}' ${github_repository.burendo_repo_template.template.0.repository}"
  }
}

resource "github_actions_secret" "burendo_repo_template_terraform_version" {
  repository      = github_repository.burendo_repo_template.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
