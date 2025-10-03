/* 
NOTE: We have 15 seats available overall, if your addition goes above that
you need a discussion with an admin member in charge of github first
*/
resource "github_team_membership" "engineering_membership_ConnorAvery" {
  team_id  = github_team.engineering.id
  username = "connoravo"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_kevinkuszyk" {
  team_id  = github_team.engineering.id
  username = "kevinkuszyk"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_phillip-stanley" {
  team_id  = github_team.engineering.id
  username = "phillip-stanley"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_Jita81" {
  team_id  = github_team.engineering.id
  username = "Jita81"
  role     = "member"
}

resource "github_team_membership" "automation_membership_burendoci" {
  team_id  = github_team.automation.id
  username = "burendoci"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_rohoolio" {
  team_id  = github_team.engineering.id
  username = "rohoolio"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_luketowell" {
  team_id  = github_team.engineering.id
  username = "luketowell"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_kathryn-dale" {
  team_id  = github_team.engineering.id
  username = "kathryn-dale"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_emily_evans" {
  team_id  = github_team.engineering.id
  username = "emilyjevans"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_joshua_douce" {
  team_id  = github_team.engineering.id
  username = "JoshuaDouceBurendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_natasha_myers" {
  team_id  = github_team.engineering.id
  username = "natashaburendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_ramon_rodriguez" {
  team_id  = github_team.engineering.id
  username = "ramonrodriguez-burendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_mauro_sorrentino" {
  team_id  = github_team.engineering.id
  username = "maurosorrentinoburendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_paul_walkington" {
  team_id  = github_team.engineering.id
  username = "paulwalkington"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_neil_dunlop" {
  team_id  = github_team.engineering.id
  username = "neildunlop"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_sam_aki" {
  team_id  = github_team.engineering.id
  username = "sam-aki"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_chris_ramsden" {
  team_id  = github_team.engineering.id
  username = "tvking"
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_matt_munro" {
  team_id  = github_team.engineering.id
  username = "mathew-munro-burendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_nick_lefley" {
  team_id  = github_team.engineering.id
  username = "NickLefleyBurendo"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_chris_warren" {
  team_id  = github_team.engineering.id
  username = "jumpertester"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_steven_moxon" {
  team_id  = github_team.engineering.id
  username = "stmo262"
  role     = "member"
}

resource "github_team_membership" "engineering_membership_ann_barr" {
  team_id  = github_team.engineering.id
  username = "annjbarr"
  role     = "member"
}
