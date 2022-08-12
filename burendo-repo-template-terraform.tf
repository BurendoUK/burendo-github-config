resource "github_repository" "burendo_repo_template_terraform" {
  name        = "burendo-repo-template-terraform"
  description = "burendo-repo-template-terraform"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = local.common_topics

  is_template = true

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner      = var.github_org
    repository = "burendo-repo-template"
  }
}

resource "github_team_repository" "burendo_repo_template_terraform_burendo" {
  repository = github_repository.burendo_repo_template_terraform.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_repo_template_terraform-admin" {
  repository = github_repository.burendo_repo_template_terraform.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_repo_template_terraform_master" {
  pattern        = github_repository.burendo_repo_template_terraform.default_branch
  repository_id  = github_repository.burendo_repo_template_terraform.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_repo_template_terraform" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_repo_template_terraform.name
}

resource "null_resource" "burendo_repo_template_terraform" {
  triggers = {
    repo = github_repository.burendo_repo_template_terraform.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_repo_template_terraform.name} '${github_repository.burendo_repo_template_terraform.description}' ${github_repository.burendo_repo_template_terraform.template.0.repository}"
  }
}

resource "github_actions_secret" "burendo_repo_template_terraform_terraform_version" {
  repository      = github_repository.burendo_repo_template_terraform.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
