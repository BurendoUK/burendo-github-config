resource "github_repository" "burendo_bid_ai_poc" {
  name             = "burendo-bid-ai-poc"
  description      = "A Bid AI PoC for assisting with the answering of bid questions using Anthropic Claude-Sonnet 3.7 via Bedrock"
  visibility       = "public"
  auto_init        = false

  allow_merge_commit     = false
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = concat(local.common_topics, local.aws_topics)

  lifecycle {
    prevent_destroy = true
  }

  template {
    owner = var.github_org
    repository = "burendo-repo-template-terraform"
  }
}

resource "github_team_repository" "burendo_bid_ai_poc_burendo" {
  repository = github_repository.burendo_bid_ai_poc.name
  team_id    = github_team.burendo.id
  permission = "push"
}

resource "github_team_repository" "burendo_bid_ai_poc_admin" {
  repository = github_repository.burendo_bid_ai_poc.name
  team_id    = github_team.engineering.id
  permission = "admin"
}

resource "github_branch_protection" "burendo_bid_ai_poc_main" {
  pattern        = github_repository.burendo_bid_ai_poc.default_branch
  repository_id     = github_repository.burendo_bid_ai_poc.name
  enforce_admins = true

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_issue_label" "burendo_bid_ai_poc" {
  for_each   = { for common_label in local.common_labels : common_label.name => common_label }
  color      = each.value.colour
  name       = each.value.name
  repository = github_repository.burendo_bid_ai_poc.name
}
