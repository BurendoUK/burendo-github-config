resource "github_repository" "burendo_handbook" {
  name        = "burendo_handbook"
  description = "The Burendo Handbook"
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

resource "github_team_repository" "burendo_handbook_burendo" {
  repository = github_repository.burendo_handbook.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_handbook-admin" {
  repository = github_repository.burendo_handbook.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_handbook_master" {
  pattern        = github_repository.burendo_handbook.default_branch
  repository_id  = github_repository.burendo_handbook.name
  enforce_admins = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_handbook" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_handbook.name
}

resource "null_resource" "burendo_handbook" {
  triggers = {
    repo = github_repository.burendo_handbook.name
  }
  provisioner "local-exec" {
    command = "./initial-commit.sh ${github_repository.burendo_handbook.name} '${github_repository.burendo_handbook.description}' ${github_repository.burendo_handbook.template.0.repository}"
  }
}

resource "github_actions_secret" "burendo_handbook_terraform_version" {
  repository      = github_repository.burendo_handbook.name
  secret_name     = "TERRAFORM_VERSION"
  plaintext_value = var.terraform_version
}
