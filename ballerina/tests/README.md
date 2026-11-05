# Tests

The suite exercises 25 representative operations covering the authenticated user, workspaces and projects, repositories, branches, tags, commits, pull requests (create, get, approve, merge), branch restriction rules, pipelines and snippets. By default every test runs against the bundled mock server (`tests/mock_service.bal`), so no credentials are required.

## Running Tests

```bash
bal test
```

To run the read-only tests against Bitbucket Cloud, set the following environment variables:

```bash
export IS_LIVE_SERVER=true
export BITBUCKET_ACCESS_TOKEN=<access token>
export BITBUCKET_WORKSPACE=<workspace slug>
export BITBUCKET_REPO_SLUG=<repository slug>
bal test --groups live_tests
```

Tests that create, modify or delete data are skipped when `IS_LIVE_SERVER` is `true`.
