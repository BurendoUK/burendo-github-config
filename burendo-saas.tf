resource "github_repository" "burendo_saas" {
  name        = "burendo-saas"
  description = "Demo SaaS subscription application with bells and whistles"
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

resource "github_team_repository" "burendo_saas_burendo" {
  repository = github_repository.burendo_saas.name
  permission = "push"
}

resource "github_team_repository" "burendo_saas-admin" {
  repository = github_repository.burendo_saas.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_saas_master" {
  branch         = github_repository.burendo_saas.default_branch
  repository     = github_repository.burendo_saas.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_saas" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_saas.name
}

resource "null_resource" "burendo_saas" {
  triggers = {
    repo = github_repository.burendo_saas.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_saas.name} '${github_repository.burendo_saas.description}' ${github_repository.burendo_saas.template.0.repository}"
  }
}

resource "github_actions_secret" "burendo_saas_terraform_version" {
  repository      = github_repository.burendo_saas.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
