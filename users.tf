/* 
NOTE: Add a comment with name if not obvious from username
 */

resource "github_membership" "engineering_membership_ChrisScottThomas" {
  username = "ChrisScottThomas"
  role     = "admin"
}

resource "github_membership" "engineering_membership_steveburtonBUR" {
  username = "steveburtonBUR"
  role     = "admin"
}

resource "github_membership" "engineering_membership_kevinkuszyk" {
  username = "kevinkuszyk"
  role     = "admin"
}

resource "github_membership" "engineering_membership_phillip-stanley" {
  username = "phillip-stanley"
  role     = "member"
}

resource "github_membership" "engineering_membership_zesh92" {
  username = "zesh92" //Zeshen Zoheb
  role     = "member"
}

resource "github_membership" "automation_membership_burendoci" {
  username = "burendoci"
  role     = "admin"
}

resource "github_membership" "engineering_membership_rohoolio" {
  username = "rohoolio" //Rowan Gill
  role     = "member"
}

resource "github_membership" "engineering_membership_luketowell" {
  username = "luketowell"
  role     = "member"
}
