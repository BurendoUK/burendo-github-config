resource "github_repository" "burendo_access_report" {
  name        = "burendo-access-report"
  description = "Storing and full and sanitised CSV data for door access reporting"
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

resource "github_team_repository" "burendo_access_report_burendo" {
  repository = github_repository.burendo_access_report.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_access_report_admin" {
  repository = github_repository.burendo_access_report.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_access_report_main" {
  pattern        = github_repository.burendo_access_report.default_branch
  repository_id  = github_repository.burendo_access_report.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_access_report" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_access_report.name
}

resource "github_actions_secret" "burendo_access_report_github_token" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "GHA_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "slack_build_notifications_webhook_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "SLACK_BUILD_NOTIFICATIONS_WEBHOOK"
  plaintext_value = var.gha_aws.slack_build_notifications_webhook
}

resource "github_actions_secret" "slack_engineering_group_id_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "SLACK_ENGINEERING_GROUP_ID"
  plaintext_value = var.gha_aws.slack_engineering_group_id
}

resource "github_actions_secret" "aws_access_key_id_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "ACTIONS_ACCESS_KEY_ID"
  plaintext_value = var.gha_aws.access_key_id
}

resource "github_actions_secret" "aws_secret_access_key_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "ACTIONS_SECRET_ACCESS_KEY"
  plaintext_value = var.gha_aws.secret_access_key
}

resource "github_actions_secret" "dev_aws_role_burendo_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "AWS_GHA_ROLE_DEV"
  plaintext_value = "arn:aws:iam::${local.account["burendo-dev"]}:role/ci"
}

resource "github_actions_secret" "prod_aws_role_burendo_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "AWS_GHA_ROLE"
  plaintext_value = "arn:aws:iam::${local.account["burendo-prod"]}:role/ci"
}

resource "github_actions_secret" "s3_bucket_name_burendo_access_report" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "S3_BUCKET_NAME"
  plaintext_value = "door-access-control"
}
resource "github_actions_secret" "s3_bucket_name_burendo_access_report_dev" {
  repository      = github_repository.burendo_access_report.name
  secret_name     = "S3_DEV_BUCKET_NAME"
  plaintext_value = "door-access-control-dev"
}
