# Release tag publishing

Finds the most recent commit of a repository, tags it as a release when `publishTag` is enabled, and lists the tags of the repository. Tag creation is a side effect and stays off by default.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Bitbucket Cloud access token with repository and pull request scopes
- Create a `Config.toml` in this directory:

  ```toml
  accessToken = "<your-access-token>"
  workspace = "<workspace-slug>"
  repoSlug = "<repository-slug>"
  tagName = "v1.0.0"
  publishTag = false
  ```

## Run the example

```bash
bal run
```
