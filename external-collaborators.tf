/*
  HANDBOOK COLLABORATORS
*/

locals {
    handbook_collaborators_github_usernames = 
    toset([   #For a new handbook collaborator, simply add GH username to this array
        "DaveHBurendo",
        "JarvBurendo",
    ])
}

resource "github_repository_collaborator" "external_collaborator_burendo_handbook_public" {
  for_each   = local.handbook_collaborators_github_usernames
  repository = "burendo-handbook-public"
  username   = "${each.key}"
  permission = "push"
}

/*
  COLLABORATORS FOR OTHER REPOS
*/

resource "github_repository_collaborator" "external_collaborator_burendo_website_lubomski" {
  repository = "burendo-website"
  username   = "lubomski"
  permission = "push"
}

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
