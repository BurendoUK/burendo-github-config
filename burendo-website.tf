resource "github_repository" "burendo_website" {
  name        = "burendo-website"
  description = "The Burendo dot com website"
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

resource "github_team_repository" "burendo_website_burendo" {
  repository = github_repository.burendo_website.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_website_admin" {
  repository = github_repository.burendo_website.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_website_main" {
  pattern        = github_repository.burendo_website.default_branch
  repository_id  = github_repository.burendo_website.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_website" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_website.name
}

resource "github_actions_secret" "aws_access_key_id_burendo_website" {
  repository      = github_repository.burendo_website.name
  secret_name     = "ACTIONS_ACCESS_KEY_ID"
  plaintext_value = var.gha_aws.access_key_id
}

resource "github_actions_secret" "aws_secret_access_key_burendo_website" {
  repository      = github_repository.burendo_website.name
  secret_name     = "ACTIONS_SECRET_ACCESS_KEY"
  plaintext_value = var.gha_aws.secret_access_key
}

resource "github_actions_secret" "aws_role_burendo_website" {
  repository      = github_repository.burendo_website.name
  secret_name     = "AWS_GHA_ROLE"
  plaintext_value = "arn:aws:iam::${local.account["burendo-prod"]}:role/ci"
}

resource "github_actions_secret" "dev_aws_role_burendo_website" {
  repository      = github_repository.burendo_website.name
  secret_name     = "AWS_GHA_ROLE_DEV"
  plaintext_value = "arn:aws:iam::${local.account["burendo-dev"]}:role/ci"
}

resource "github_actions_secret" "aws_acc_prod_burendo_website" {
  repository      = github_repository.burendo_website.name
  secret_name     = "AWS_GHA_ACC_PROD"
  plaintext_value = local.account["burendo-prod"]
}
