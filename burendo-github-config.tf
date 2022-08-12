locals {
  burendo_github_config_pipeline_name = "burendo_github_config"
}

resource "github_repository" "burendo_github_config" {
  name        = "burendo-github-config"
  description = "IAC repository of all GitHub repositories in this Org"
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

resource "github_team_repository" "burendo_github_config_burendo" {
  repository = github_repository.burendo_github_config.name
  permission = "push"
}

resource "github_team_repository" "burendo_github_config-admin" {
  repository = github_repository.burendo_github_config.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_github_config_master" {
  branch         = github_repository.burendo_github_config.default_branch
  repository_id  = github_repository.burendo_github_config.name
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

resource "github_issue_label" "burendo_github_config" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_github_config.name
}

resource "null_resource" "burendo_github_config" {
  triggers = {
    repo = github_repository.burendo_github_config.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_github_config.name} '${github_repository.burendo_github_config.description}' ${github_repository.burendo_github_config.template.0.repository}"
  }
}

resource "github_repository_webhook" "burendo_github_config" {
  repository = github_repository.burendo_github_config.name
  events     = ["push"]

  configuration {
    url          = "https://${var.aws_ci_domain_name}/api/v1/teams/${var.aws_ci_team}/pipelines/${local.burendo_github_config_pipeline_name}/resources/${github_repository.burendo_github_config.name}/check/webhook?webhook_token=${var.github_webhook_token}"
    content_type = "form"
  }
}

resource "github_repository_webhook" "burendo_github_config_pr" {
  repository = github_repository.burendo_github_config.name
  events     = ["pull_request"]

  configuration {
    url          = "https://${var.aws_ci_domain_name}/api/v1/teams/${var.aws_ci_team}/pipelines/${local.burendo_github_config_pipeline_name}/resources/${github_repository.burendo_github_config.name}-pr/check/webhook?webhook_token=${var.github_webhook_token}"
    content_type = "form"
  }
}
