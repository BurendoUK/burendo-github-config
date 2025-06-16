/*
  HANDBOOK COLLABORATORS
*/

locals {
  handbook_public_collaborators_github_usernames = toset([
    "waljj1",        #Paul Glover
    "HBoulton20",    #Heather Bolton
    "warranmav",     #Warran Mav
    "BurendoKate",   #Kate Smith
    "jrsscott",      #James Scott
    "rhrh19",        #Richard Hardicre
    "RobynBrooke25", #Robyn Brooke
    "Sobiamalik423", #Sobia Malik
  ])

  handbook_private_collaborators_github_usernames = toset([
  ])

  oddfellows_private_collaborators_github_usernames = toset([
    "simonf-burendo", # Simon Futter Contractor
  ])

  data_dashboard_public_collaborators_github_usernames = toset([
    "A-Ashiq",        #Afaan Ashiq
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

resource "github_repository_collaborator" "external_collaborator_burendo_oddfellows_pt_frontend" {
  for_each   = local.oddfellows_private_collaborators_github_usernames
  repository = "burendo-oddfellows-pt-frontend"
  username   = each.key
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_data_dashboard_api_public" {
  for_each   = local.data_dashboard_public_collaborators_github_usernames
  repository = "data-dashboard-api"
  username   = each.key
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_data_dashboard_frontend_public" {
  for_each   = local.data_dashboard_public_collaborators_github_usernames
  repository = "data-dashboard-frontend"
  username   = each.key
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_data_dashboard_infra_public" {
  for_each   = local.data_dashboard_public_collaborators_github_usernames
  repository = "data-dashboard-infra"
  username   = each.key
  permission = "push"
}

resource "github_repository_collaborator" "external_collaborator_burendo_nhs_dashboard_tooling_private" {
  for_each   = local.data_dashboard_public_collaborators_github_usernames
  repository = "burendo-nhs-dashboard-tooling"
  username   = each.key
  permission = "push"
}
