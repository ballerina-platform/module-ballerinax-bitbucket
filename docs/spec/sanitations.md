_Author_:  @DimuthuMadushan \
_Created_: 2026/09/30 \
_Updated_: 2026/11/04 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Bitbucket.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/bitbucket/bitbucket/2.0/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Add a top-level `security` requirement.

   The specification declares the `basic`, `oauth2` and `api_key` security schemes but no top-level `security`, so the generator emitted a client without `auth`. The three schemes are now listed as alternative requirements. This change was made in the original specification.

2. Assign operationIds.

   192 of the 294 operations had no `operationId` and the rest used inconsistent styles (`list_hook_events`). Every operation now has a concise camelCase `list*`/`get*`/`create*`/`update*`/`delete*` name of at most 37 characters, recorded in `ai-mappings.json`. Names that differed only by a plural `s` (`getRepositoryRunner`/`getRepositoryRunners`, `deleteCache`/`deleteCaches`) were made distinct.

3. Make operation summaries unique.

   Five summaries were shared by two operations (default reviewer, pull request activity log, pipeline variable creation). They now name the repository, project, team or user they apply to. This change was made in the original specification.

4. Rename inline object titles that contain spaces.

   The inline schemas titled `Rendered Pull Request Markup` and `Pull Request Commit` produced invalid identifiers (`Rendered\ Pull\ Request\ Markup`). Their titles are now `RenderedPullRequestMarkup` and `PullRequestCommit`. This change was made in the original specification.

5. Rename schemas.

   The generic `Object` schema is now `GenericObject`, the two `BitbucketAppsPermissionsSerializers...UpdateSchema` schemas are `ProjectPermissionUpdate` and `RepoPermissionUpdate`, and `ErrorError`, `GPGAccountKey` and `Branchrestriction` are `ErrorDetail`, `GpgAccountKey` and `BranchRestriction`.

6. Add descriptions for the request bodies of `POST /repositories/{workspace}/{repo_slug}/pullrequests/{pull_request_id}/merge` and `POST /repositories/{workspace}/{repo_slug}/refs/tags`. This change was made in the original specification.

7. Fill missing property, response and request body descriptions.

   The generated records had `undocumented field` warnings wherever a schema property had no description, and some operations had blank response or request body descriptions. Descriptions were added to 194 properties, 4 responses and 4 request bodies, and each bare `$ref` property that gained one was wrapped as `allOf: [{$ref}]` plus `description` (94 properties). Existing descriptions were left unchanged. This change was made in the original specification with `tooling/apply_descriptions.py`.

   Flatten merges inline objects that are identical into one schema, so every copy in a merged group has the same description. The `links` objects of `project_group_permission`, `project_user_permission`, `repository_group_permission` and `repository_user_permission` read "Hypermedia links related to the permission.", and `subject_types.repository` and `subject_types.workspace` read "Event types available for this subject type." With different texts they generate separate record types (`ProjectUserPermissionLinks`, `SubjectTypesWorkspace`, …).

8. Describe the remaining fields of inline objects.

   Seventeen fields of inline objects still had no description: the branching-model `branch`, the commit `hash`, the pull request branch `name`, the rendered pull request `title`, `description` and `reason`, the `subject_types` event `links`, the repository `clone` links, the pipeline schedule target `selector`, and the `href` and `name` of every inline link object. They were described in the original specification with `tooling/apply_descriptions.py`. Every inline link object's `href` and `name` gets the same text ("URL of the linked resource.", "Display name of the linked resource."), as do the three rendered pull request fields, so identical objects still generate a single record type.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
Note: The license year is hardcoded to 2024, change if necessary.
