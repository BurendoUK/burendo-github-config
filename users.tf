resource "github_team_membership" "engineering_membership_ChrisScottThomas" {
  team_id  = github_team.engineering.id
  username = "ChrisScottThomas"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_steveburtonBUR" {
  team_id  = github_team.engineering.id
  username = "steveburtonBUR"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_kevinkuszyk" {
  team_id  = github_team.engineering.id
  username = "kevinkuszyk"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_nomad3k" {
  team_id  = github_team.engineering.id
  username = "nomad3k"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_phillip-stanley" {
  team_id  = github_team.engineering.id
  username = "phillip-stanley"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_connoravo" {
  team_id  = github_team.engineering.id
  username = "connoravo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_awslee" {
  team_id  = github_team.engineering.id
  username = "awslee"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_zesh92" {
  team_id  = github_team.engineering.id
  username = "zesh92"
  role     = "member"
}

resource "github_team_membership" "automation_membership_burendoci" {
  team_id  = github_team.automation.id
  username = "burendoci"
  role     = "maintainer"
}