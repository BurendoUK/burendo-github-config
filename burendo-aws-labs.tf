resource "github_repository" "burendo_aws_labs" {
  name        = "burendo-aws-labs"
  description = "A repo containing educational lab material for AWS"
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

resource "github_team_repository" "burendo_aws_labs_burendo" {
  repository = github_repository.burendo_aws_labs.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_aws_labs_admin" {
  repository = github_repository.burendo_aws_labs.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_aws_labs_main" {
  pattern        = github_repository.burendo_aws_labs.default_branch
  repository_id  = github_repository.burendo_aws_labs.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_aws_labs" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_aws_labs.name
}

resource "github_actions_secret" "burendo_aws_labs_terraform_version" {
  repository      = github_repository.burendo_aws_labs.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}

resource "github_actions_secret" "burendo_aws_labs_github_token" {
  repository      = github_repository.burendo_aws_labs.name
  secret_name     = "GHA_TOKEN"
  plaintext_value = var.github_token
}
