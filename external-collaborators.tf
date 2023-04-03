/*
  HANDBOOK COLLABORATORS
*/

locals {
  handbook_public_collaborators_github_usernames = toset([
    "DaveHBurendo",
    "JarvBurendo",
    "garygreenburendo",
    "waljj1",
  ])

  handbook_private_collaborators_github_usernames = toset([
  ])
}

resource "github_repository_collaborator" "external_collaborator_burendo_handbook_public" {
  for_each   = local.handbook_public_collaborators_github_usernames
  repository = "burendo-handbook-public"
  username   = each.key
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_burendo_handbook_private" {
  for_each   = local.handbook_private_collaborators_github_usernames
  repository = "burendo-handbook-private"
  username   = each.key
  permission = "push"
}

/*
  COLLABORATORS FOR OTHER REPOS
*/

resource "github_repository_collaborator" "external_collaborator_generator_aws_api_xlasercut" {
  repository = "generator-aws-api"
  username   = "xLasercut"
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_generator_aws_api_jaklinger" {
  repository = "generator-aws-api"
  username   = "jaklinger"
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_bad_community_toolkit_jordierochburendo" {
  repository = "bad-community-toolkit"
  username   = "JordieRochBurendo"
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_bad_community_toolkit_garygreenburendo" {
  repository = "bad-community-toolkit"
  username   = "garygreenburendo"
  permission = "push"
}