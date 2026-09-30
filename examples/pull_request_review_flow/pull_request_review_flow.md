# Pull request review flow

Lists the open pull requests of a repository, fetches one for review and, when `approveAndMerge` is enabled, approves and merges it. Approval and merge are side effects and stay off by default.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Bitbucket Cloud access token with repository and pull request scopes
- Create a `Config.toml` in this directory:

  ```toml
  accessToken = "<your-access-token>"
  workspace = "<workspace-slug>"
  repoSlug = "<repository-slug>"
  pullRequestId = 1
  approveAndMerge = false
  ```

## Run the example

```bash
bal run
```
