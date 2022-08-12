resource "github_team" "engineering" {
  name    = "engineering"
  privacy = "closed"
}

resource "github_team" "automation" {
  name    = "automation"
  privacy = "secret"
}
