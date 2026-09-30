_Author_:  @DimuthuMadushan \
_Created_: 2026/09/30 \
_Updated_: 2026/09/30 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Bitbucket.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/bitbucket/bitbucket/2.0/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Add a top-level `security` requirement.

   The specification declares the `basic`, `oauth2` and `api_key` security schemes but no top-level `security`, so the generator emitted a client without `auth`. The three schemes are now listed as alternative requirements.

2. Assign operationIds.

   192 of the 294 operations had no `operationId` and the rest used inconsistent styles (`list_hook_events`). Every operation now has a concise camelCase `list*`/`get*`/`create*`/`update*`/`delete*` name of at most 37 characters, recorded in `ai-mappings.json`. Names that differed only by a plural `s` (`getRepositoryRunner`/`getRepositoryRunners`, `deleteCache`/`deleteCaches`) were made distinct.

3. Make operation summaries unique.

   Five summaries were shared by two operations (default reviewer, pull request activity log, pipeline variable creation). They now name the repository, project, team or user they apply to.

4. Rename inline object titles that contain spaces.

   The inline schemas titled `Rendered Pull Request Markup` and `Pull Request Commit` produced invalid identifiers (`Rendered\ Pull\ Request\ Markup`). Their titles are now `RenderedPullRequestMarkup` and `PullRequestCommit`.

5. Rename schemas.

   The generic `Object` schema is now `GenericObject`, the two `BitbucketAppsPermissionsSerializers...UpdateSchema` schemas are `ProjectPermissionUpdate` and `RepoPermissionUpdate`, and `ErrorError`, `GPGAccountKey` and `Branchrestriction` are `ErrorDetail`, `GpgAccountKey` and `BranchRestriction`.

6. Add descriptions for the request bodies of `POST /repositories/{workspace}/{repoSlug}/pullrequests/{pullRequestId}/merge` and `POST /repositories/{workspace}/{repoSlug}/refs/tags`.

Items 1, 3 and 4 are re-applied by `docs/spec/fix_aligned.py` on the aligned specification.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
Note: The license year is hardcoded to 2024, change if necessary.
