resource "github_repository" "generator_aws_api" {
  name        = "generator-aws-api"
  description = "Burendo OpenSource API Scaffolder"
  visibility  = "private"
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

resource "github_team_repository" "generator_aws_api_burendo" {
  repository = github_repository.generator_aws_api.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "generator_aws_api_admin" {
  repository = github_repository.generator_aws_api.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "generator_aws_api_main" {
  pattern        = github_repository.generator_aws_api.default_branch
  repository_id  = github_repository.generator_aws_api.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "generator_aws_api" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.generator_aws_api.name
}

resource "null_resource" "generator_aws_api" {
  triggers = {
    repo = github_repository.generator_aws_api.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.generator_aws_api.name} '${github_repository.generator_aws_api.description}' ${github_repository.generator_aws_api.template.0.repository}"
  }
}

resource "github_actions_secret" "generator_aws_api_terraform_version" {
  repository      = github_repository.generator_aws_api.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
