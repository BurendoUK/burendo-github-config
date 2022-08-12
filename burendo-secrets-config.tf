locals {
  burendo_secrets_config_pipeline_name = "burendo_secrets_config"
}

resource "github_repository" "burendo_secrets_config" {
  name        = "burendo-secrets-config"
  description = "This repo contains secrets configuration for Burendo's AWS infrastructure."
  visibility  = "private"
  auto_init   = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = concat(local.common_topics, local.aws_topics)

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner      = var.github_org
    repository = "burendo-repo-template-terraform"
  }
}

resource "github_team_repository" "burendo_secrets_config_burendo" {
  repository = github_repository.burendo_secrets_config.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_secrets_config-admin" {
  repository = github_repository.burendo_secrets_config.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_secrets_config_master" {
  pattern        = github_repository.burendo_secrets_config.default_branch
  repository_id  = github_repository.burendo_secrets_config.name
  enforce_admins = false

  required_status_checks {
    strict   = true
    contexts = ["ci-ci/status"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_secrets_config" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_secrets_config.name
}

resource "null_resource" "burendo_secrets_config" {
  triggers = {
    repo = github_repository.burendo_secrets_config.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_secrets_config.name} '${github_repository.burendo_secrets_config.description}' ${github_repository.burendo_secrets_config.template.0.repository}"
  }
}
