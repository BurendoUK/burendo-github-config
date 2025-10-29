/*
NOTE: We have 27 seats available overall, if your addition goes above that
you need a discussion with an admin member in charge of github first
*/
resource "github_team_membership" "engineering_membership_ConnorAvery" {
  team_id  = github_team.engineering.id
  username = "connoravo" // Connor Avery
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_kevinkuszyk" {
  team_id  = github_team.engineering.id
  username = "kevinkuszyk" // Kevin Kuszyk
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_phillip-stanley" {
  team_id  = github_team.engineering.id
  username = "phillip-stanley" // Phillip Stanley
  role     = "member"
}

resource "github_team_membership" "engineering_membership_Jita81" {
  team_id  = github_team.engineering.id
  username = "Jita81" // Paul Glover
  role     = "member"
}

resource "github_team_membership" "automation_membership_burendoci" {
  team_id  = github_team.automation.id
  username = "burendoci" // Burendo CI Bot
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_rohoolio" {
  team_id  = github_team.engineering.id
  username = "rohoolio" // Rowan Gill
  role     = "member"
}

resource "github_team_membership" "engineering_membership_luketowell" {
  team_id  = github_team.engineering.id
  username = "luketowell" // Luke Towell
  role     = "member"
}

resource "github_team_membership" "engineering_membership_kathryn-dale" {
  team_id  = github_team.engineering.id
  username = "kathryn-dale" // Kathryn Dale
  role     = "member"
}

resource "github_team_membership" "engineering_membership_emily_evans" {
  team_id  = github_team.engineering.id
  username = "emilyjevans" // Emily Evans
  role     = "member"
}

resource "github_team_membership" "engineering_membership_joshua_douce" {
  team_id  = github_team.engineering.id
  username = "JoshuaDouceBurendo" // Joshua Douce
  role     = "member"
}

resource "github_team_membership" "engineering_membership_natasha_myers" {
  team_id  = github_team.engineering.id
  username = "natashaburendo" // Natasha Myers
  role     = "member"
}

resource "github_team_membership" "engineering_membership_ramon_rodriguez" {
  team_id  = github_team.engineering.id
  username = "ramonrodriguez-burendo"  // Ramon Rodriguez
  role     = "member"
}

resource "github_team_membership" "engineering_membership_mauro_sorrentino" {
  team_id  = github_team.engineering.id
  username = "maurosorrentinoburendo"  // Mauro Sorrentino
  role     = "member"
}

resource "github_team_membership" "engineering_membership_paul_walkington" {
  team_id  = github_team.engineering.id
  username = "paulwalkington" // Paul Walkington
  role     = "member"
}

resource "github_team_membership" "engineering_membership_neil_dunlop" {
  team_id  = github_team.engineering.id
  username = "neildunlop" // Neil Dunlop
  role     = "member"
}

resource "github_team_membership" "engineering_membership_sam_aki" {
  team_id  = github_team.engineering.id
  username = "sam-aki" // Sam Aki
  role     = "member"
}

resource "github_team_membership" "engineering_membership_chris_ramsden" {
  team_id  = github_team.engineering.id
  username = "tvking" // Chris Ramsden
  role     = "maintainer"
}

resource "github_team_membership" "engineering_membership_matt_munro" {
  team_id  = github_team.engineering.id
  username = "mathew-munro-burendo" // Matt Munro
  role     = "member"
}

resource "github_team_membership" "engineering_membership_nick_lefley" {
  team_id  = github_team.engineering.id
  username = "NickLefleyBurendo" // Nick Lefley
  role     = "member"
}

resource "github_team_membership" "engineering_membership_chris_warren" {
  team_id  = github_team.engineering.id
  username = "jumpertester" // Chris Warren
  role     = "member"
}

resource "github_team_membership" "engineering_membership_steven_moxon" {
  team_id  = github_team.engineering.id
  username = "stmo262" // Steven Moxon
  role     = "member"
}

resource "github_team_membership" "engineering_membership_ann_barr" {
  team_id  = github_team.engineering.id
  username = "annjbarr" // Ann Barr
  role     = "member"
}

resource "github_team_membership" "engineering_membership_gordon_brown" {
  team_id  = github_team.engineering.id
  username = "gordonbrown" // Gordon Brown
  role     = "member"
}

resource "github_team_membership" "engineering_membership_mark_matthews" {
  team_id  = github_team.engineering.id
  username = "mark-r-m" // Mark Matthews
  role     = "member"
}
