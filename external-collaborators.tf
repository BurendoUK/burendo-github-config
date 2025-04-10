/*
  HANDBOOK COLLABORATORS
*/

locals {
  handbook_public_collaborators_github_usernames = toset([
    "waljj1",      #Paul Glover
    "HBoulton20",  #Heather Bolton
    "warranmav",   #Warran Mav
    "BurendoKate", #Kate Smith
    "jrsscott",    #James Scott
    "rhrh19",      #Richard Hardicre
    "RobynBrooke25",
    "jektonoporkins", #ChrisTestAccount #Robyn Brooke
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
