# burendo-github-config
IAC repository of all GitHub repositories in this Org

## How to create a new GitHub repository for the Burendo Org

This process is currently intended for use with *public*, not private repositories.

1. There are now standards for creating a new repository, dependant on type:
   - _*Terraform repositories:*_ Copy `terraform-template-repository.tf.sample` to a new `.tf` file to create a standard Terraform repository, including Terraform templates and CI pipeline.
   - _*container repositories:*_ Copy `container-template-repository.tf.sample` to a new `.tf` file to create a standard container repository, including GitHub Actions pipeline.  
      - Follow the standard naming policy for container images and their VCS repositories to be identically named.
   - _*All other repositories:*_ Copy `template-repository.tf.sample` to a new `.tf` file to create a standard empty repository
1. Update the `github_repository` resource name (example) using underscores as separators if required. Its `name`  should use hyphen separators if required, and `description` attributes should be a single sentence. 
1. Replace every instance of `example` with the name of your repo using underscores.
1. When creating a new template repo, and the template repo will hold GitHub Actions workflows, ensure you disable github actions using the GitHub UI.  `Settings > Actions > General > Disable actions`

## How to add users to teams

Add a new resource to the `users.tf` file, appending their GitHub username to the resource.  There are examples available. 

There are three teams to choose from:

`Burendo` - This is the default team for any Burendo employee that is not part of the engineering practice, and likely does not require any elevated privileges.  This team is added to each repo with `read/write` access.
`Engineering` - This team has elevated privileges to all repositories by default, and consists of the Engineering Practice members.
`Automation` - This is for service users aka, bots.

By default you should create users with the `member` role. These roles do not have any effect inside repositories and should remain as such.  Repository privileges are controlled in the repositories themselves.

### Naming convention
Repo names should avoid using any technology within its name, in case the technology changes which would lead to confusion.
Infrastructure repos should be prefixed with platform e.g. `burendo-aws`.

## Renaming terraform state files
If you need to rename the terraform state file for any reason:

1) Rename the state file in S3 while no pipelines are rolling out.
2) Update the repo terraform.tf.j2 backend s3 resource key value to the new state file name.
3) PR / Terraform apply out to the environment - there should be no infrastructure changes.

## Handbook access

There are two types of Handbook access that will be requested from Burendoers - public content and private content. They will do this via the `#practice-engineering` slack channel. You will only need their username for either.

**Access should only be given to current Burendoers**. If people outside Burendo spot mistakes or otherwise and would like to contribute fixes to public content, the guide for them is to fork the public repository and submit a PR, so they don't need access in code.

### Public access

To grant access to the public repo, you need to do the following:

1. Add their GitHub username to the `local.handbook_public_collaborators_github_usernames` array in (external-collaborators.tf)[external-collaborators.tf].
1. Create a PR and get this approved and merged.

Once done, public access **does not need to be removed** after the contributor has done and can stay while they are in Burendo.

### Private access

To grant access to the private repo, you need to do the following:

1. Add their GitHub username to the `local.handbook_private_collaborators_github_usernames` array in (external-collaborators.tf)[external-collaborators.tf].
1. Create a PR and get this approved and merged.
1. **Reverse the process when they have had their contribution PR merged**

The reason private access should be removed afterwards is because it costs to give access to a private repo. **It is the responsibility of the person giving access to communicate with the person gaining access and then remove the access when they have finished**.

### Offboarding

When offboarding full members check both (users.tf)[users.tf] and (membership.tf)[membership.tf] for user resources.  When offboarding non-members (external collaborators), they should be removed from (external-collaborators.tf)[external-collaborators.tf]
