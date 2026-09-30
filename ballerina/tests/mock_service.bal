// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Delete a repository
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + redirect_to - If a repository has been moved to a new location, use this parameter to
    # show users a friendly message in the Bitbucket UI that the repository
    # has moved to a new location. However, a GET to this endpoint will still
    # return a 404
    # + return - returns can be any of following types 
    # http:NoContent (Indicates successful deletion)
    # http:Forbidden (If the caller either does not have admin access to the repository, or the repository is set to read-only.)
    # http:NotFound (If the repository does not exist.)
    resource function delete repositories/[string workspace]/[string repoSlug](string? redirect_to) returns http:NoContent|ErrorForbidden|ErrorNotFound {
        return http:NO_CONTENT;
    }

    # Delete a branch
    #
    # + name - The name of the branch
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:NoContent (Indicates that the specified branch was successfully deleted)
    # http:Forbidden (If the repository is private and the authenticated user does not have
# access to it.
# )
    # http:NotFound (The specified repository or branch does not exist.)
    resource function delete repositories/[string workspace]/[string repoSlug]/refs/branches/[string name]() returns http:NoContent|ErrorForbidden|ErrorNotFound {
        return http:NO_CONTENT;
    }

    # Get a repository
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The repository object)
    # http:Forbidden (If the repository is private and the authenticated user does not have access to it.)
    # http:NotFound (If no repository exists at this location.)
    resource function get repositories/[string workspace]/[string repoSlug]() returns Repository|ErrorForbidden|ErrorNotFound {
        return mockRepository();
    }

    # Get a commit
    #
    # + workspace - The workspace ID (slug) or UUID surrounded by curly-braces
    # + repoSlug - The repository slug or UUID surrounded by curly-braces
    # + 'commit - The commit hash
    # + return - The commit, or a not found error
    resource function get repositories/[string workspace]/[string repoSlug]/'commit/[string 'commit]() returns Commit|ErrorNotFound {
        return mockCommit();
    }

    resource function get repositories/[string workspace]/[string repoSlug]/branch\-restrictions(string? kind, string? pattern) returns PaginatedBranchRestrictions|ErrorUnauthorized|ErrorForbidden|ErrorNotFound {
        PaginatedBranchRestrictions result = {size: 1, page: 1, pagelen: 10, values: [mockBranchRestriction()]};
        return result;
    }

    # List commits
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (A paginated list of commits)
    # http:NotFound (If the specified repository does not exist.)
    resource function get repositories/[string workspace]/[string repoSlug]/commits() returns PaginatedChangeset|ErrorNotFound {
        PaginatedChangeset result = {size: 1, page: 1, pagelen: 10, values: [mockCommit()]};
        return result;
    }

    # List pipelines
    #
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID surrounded by curly-braces, for example `{workspace UUID}`
    # + repoSlug - The repository
    # + creatorUuid - The UUID of the creator of the pipeline to filter by
    # + targetRefType - The type of the reference to filter by
    # + targetRefName - The reference name to filter by
    # + targetBranch - The name of the branch to filter by
    # + targetCommitHash - The revision to filter by
    # + targetSelectorPattern - The pipeline pattern to filter by
    # + targetSelectorType - The type of pipeline to filter by
    # + createdOn - The creation date to filter by
    # + triggerType - The trigger type to filter by
    # + status - The pipeline status to filter by
    # + sort - The attribute name to sort on
    # + page - The page number of elements to retrieve
    # + pagelen - The maximum number of results to return
    # + return - The matching pipelines 
    resource function get repositories/[string workspace]/[string repoSlug]/pipelines(@http:Query {name: "creator.uuid"} string? creatorUuid, @http:Query {name: "target.ref_type"} "BRANCH"|"TAG"|"ANNOTATED_TAG"? targetRefType, @http:Query {name: "target.ref_name"} string? targetRefName, @http:Query {name: "target.branch"} string? targetBranch, @http:Query {name: "target.commit.hash"} string? targetCommitHash, @http:Query {name: "target.selector.pattern"} string? targetSelectorPattern, @http:Query {name: "target.selector.type"} "BRANCH"|"TAG"|"CUSTOM"|"PULLREQUESTS"|"DEFAULT"? targetSelectorType, @http:Query {name: "created_on"} string? createdOn, @http:Query {name: "trigger_type"} "PUSH"|"MANUAL"|"SCHEDULED"|"PARENT_STEP"? triggerType, "PARSING"|"PENDING"|"PAUSED"|"HALTED"|"BUILDING"|"ERROR"|"PASSED"|"FAILED"|"STOPPED"|"UNKNOWN"? status, "creator.uuid"|"created_on"|"run_creation_date"? sort, int:Signed32 page = 1, int:Signed32 pagelen = 10) returns PaginatedPipelines {
        PaginatedPipelines result = {size: 1, page: 1, pagelen: 10, values: [{"type": "pipeline", uuid: "{7d8e9f00-1a2b-4c3d-8e4f-5a6b7c8d9e0f}", build_number: 15}]};
        return result;
    }

    # List pull requests
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + state - Only return pull requests that are in this state. This parameter can be repeated
    # + return - returns can be any of following types 
    # http:Ok (All pull requests on the specified repository)
    # http:Unauthorized (If the repository is private and the request was not authenticated.)
    # http:NotFound (If the specified repository does not exist.)
    resource function get repositories/[string workspace]/[string repoSlug]/pullrequests("OPEN"|"MERGED"|"DECLINED"|"SUPERSEDED"? state) returns PaginatedPullrequests|http:Unauthorized|ErrorNotFound {
        PaginatedPullrequests result = {size: 1, page: 1, pagelen: 10, values: [mockPullRequest()]};
        return result;
    }

    # Get a pull request
    #
    # + pullRequestId - The id of the pull request
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The pull request object)
    # http:Unauthorized (If the repository is private and the request was not authenticated.)
    # http:NotFound (If the repository or pull request does not exist)
    resource function get repositories/[string workspace]/[string repoSlug]/pullrequests/[int pullRequestId]() returns Pullrequest|http:Unauthorized|ErrorNotFound {
        return mockPullRequest();
    }

    # Get a branch
    #
    # + name - The name of the branch
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The branch object)
    # http:Forbidden (If the repository is private and the authenticated user does not have
# access to it.
# )
    # http:NotFound (The specified repository or branch does not exist.)
    resource function get repositories/[string workspace]/[string repoSlug]/refs/branches/[string name]() returns Branch|ErrorForbidden|ErrorNotFound {
        return mockBranch();
    }

    # List tags
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + q -
    # Query string to narrow down the response as per
    # [filtering and sorting](/cloud/bitbucket/rest/intro/#filtering)
    # + sort -
    # Field by which the results should be sorted as per
    # [filtering and sorting](/cloud/bitbucket/rest/intro/#filtering). The `name`
    # field is handled specially for tags in that, if specified as the sort field, it
    # uses a natural sort order instead of the default lexicographical sort order. For example,
    # it will return ['1.1', '1.2', '1.10'] instead of ['1.1', '1.10', '1.2']
    # + return - returns can be any of following types 
    # http:Ok (A paginated list of tags matching any filter criteria that were provided)
    # http:Forbidden (If the repository is private and the authenticated user does not have
# access to it.
# )
    # http:NotFound (The specified repository does not exist.)
    resource function get repositories/[string workspace]/[string repoSlug]/refs/tags(string? q, string? sort) returns PaginatedTags|ErrorForbidden|ErrorNotFound {
        PaginatedTags result = {size: 1, page: 1, pagelen: 10, values: [mockTag()]};
        return result;
    }

    # Get current user
    #
    # + return - returns can be any of following types 
    # http:Ok (The current user)
    # http:Unauthorized (When the request wasn't authenticated.)
    resource function get user() returns Account|ErrorUnauthorized {
        return mockAccount();
    }

    # Get a user
    #
    # + selectedUser - This can either be an Atlassian Account ID OR the UUID of the account,
    # surrounded by curly-braces, for example: `{account UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The user object)
    # http:NotFound (If no user exists for the specified UUID, or if the specified account is a team account, not a personal account.)
    resource function get users/[string selectedUser]() returns Account|ErrorNotFound {
        return mockAccount();
    }

    # Get a workspace
    #
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The workspace)
    # http:NotFound (If no workspace exists for the specified name or UUID.)
    resource function get workspaces/[string workspace]() returns Workspace|ErrorNotFound {
        return mockWorkspace();
    }

    # List projects in a workspace
    #
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The list of projects in this workspace)
    # http:NotFound (A workspace doesn't exist at this location.)
    resource function get workspaces/[string workspace]/projects() returns PaginatedProjects|ErrorNotFound {
        PaginatedProjects result = {size: 1, page: 1, pagelen: 10, values: [mockProject()]};
        return result;
    }

    # Create a repository
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + payload - The repository that is to be created. Note that most object elements are optional. Elements "owner" and "full_name" are ignored as the URL implies them 
    # + return - returns can be any of following types 
    # http:Ok (The newly created repository)
    # http:BadRequest (If the input document was invalid, or if the caller lacks the privilege to create repositories under the targeted account.)
    # http:Unauthorized (If the request was not authenticated.)
    resource function post repositories/[string workspace]/[string repoSlug](@http:Payload Repository payload) returns RepositoryOk|ErrorBadRequest|ErrorUnauthorized {
        return <RepositoryOk>{body: mockRepository()};
    }

    resource function post repositories/[string workspace]/[string repoSlug]/branch\-restrictions(@http:Payload BranchRestriction payload) returns BranchRestriction|ErrorUnauthorized|ErrorForbidden|ErrorNotFound {
        return mockBranchRestriction();
    }

    # Create a pull request
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + payload - The new pull request 
    # + return - returns can be any of following types 
    # http:Created (The newly created pull request)
    # http:BadRequest (If the input document was invalid, or if the caller lacks the privilege to create repositories under the targeted account.)
    # http:Unauthorized (If the request was not authenticated.)
    resource function post repositories/[string workspace]/[string repoSlug]/pullrequests(@http:Payload Pullrequest payload) returns Pullrequest|ErrorBadRequest|ErrorUnauthorized {
        return mockPullRequest();
    }

    # Approve a pull request
    #
    # + pullRequestId - The id of the pull request
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Ok (The `participant` object recording that the authenticated user approved the pull request)
    # http:Unauthorized (The request wasn't authenticated.)
    # http:NotFound (The specified pull request or the repository does not exist.)
    resource function post repositories/[string workspace]/[string repoSlug]/pullrequests/[int pullRequestId]/approve() returns ParticipantOk|ErrorUnauthorized|ErrorNotFound {
        return <ParticipantOk>{body: {"type": "participant", user: mockAccount(), role: "REVIEWER", approved: true, state: "approved", participated_on: "2024-02-22T12:00:00.000000+00:00"}};
    }

    # Merge a pull request
    #
    # + pullRequestId - The id of the pull request
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + async - Default value is false.
    # When set to true, runs merge asynchronously and
    # immediately returns a 202 with polling link to
    # the task-status API in the Location header.
    # When set to false, runs merge and waits for it to
    # complete, returning 200 when it succeeds. If the
    # duration of the merge exceeds a timeout threshold,
    # the API returns a 202 with polling link to the
    # task-status API in the Location header
    # + payload - Merge strategy, commit message and branch-closing options 
    # + return - returns can be any of following types 
    # http:Ok (The pull request object)
    # http:Accepted (In the Location header, the URL to poll for the pull request merge status)
    # http:Conflict (Unable to merge because one of the refs involved changed while attempting to merge)
    # http:Response (If the merge took too long and timed out.
# In this case the caller should retry the request later)
    resource function post repositories/[string workspace]/[string repoSlug]/pullrequests/[int pullRequestId]/merge(boolean? async, @http:Payload PullrequestMergeParameters payload) returns PullrequestOk|http:Accepted|http:Conflict|http:Response {
        Pullrequest merged = mockPullRequest();
        merged.state = "MERGED";
        return <PullrequestOk>{body: merged};
    }

    # Create a branch
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Created (The newly created branch object)
    # http:Forbidden (If the repository is private and the authenticated user does not have
# access to it.
# )
    # http:NotFound (The specified repository or branch does not exist.)
    resource function post repositories/[string workspace]/[string repoSlug]/refs/branches() returns Branch|ErrorForbidden|ErrorNotFound {
        return mockBranch();
    }

    # Create a tag
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + payload - Name and target commit of the tag to create 
    # + return - returns can be any of following types 
    # http:Created (The newly created tag)
    # http:BadRequest (If the target hash is missing, ambiguous, or invalid, or if the name is not provided.)
    resource function post repositories/[string workspace]/[string repoSlug]/refs/tags(@http:Payload Tag payload) returns Tag|ErrorBadRequest {
        return mockTag();
    }

    # Create a snippet
    #
    # + payload - The new snippet object 
    # + return - returns can be any of following types 
    # http:Created (The newly created snippet object)
    # http:Unauthorized (If the request was not authenticated)
    resource function post snippets(@http:Payload Snippet payload) returns Snippet|ErrorUnauthorized {
        return mockSnippet();
    }

    # Create a project in a workspace
    #
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + return - returns can be any of following types 
    # http:Created (A new project has been created)
    # http:Forbidden (The user requesting to create a project does not have the necessary permissions.)
    # http:NotFound (A workspace doesn't exist at this location.)
    resource function post workspaces/[string workspace]/projects(@http:Payload Project payload) returns Project|ErrorForbidden|ErrorNotFound {
        return mockProject();
    }

    # Update a repository
    #
    # + repoSlug - This can either be the repository slug or the UUID of the repository,
    # surrounded by curly-braces, for example: `{repository UUID}`
    # + workspace - This can either be the workspace ID (slug) or the workspace UUID
    # surrounded by curly-braces, for example: `{workspace UUID}`
    # + payload - The repository that is to be updated 
    # + return - returns can be any of following types 
    # http:Ok (The existing repository has been updated)
    # http:Created (A new repository has been created)
    # http:BadRequest (If the input document was invalid, or if the caller lacks the privilege to create repositories under the targeted account.)
    # http:Unauthorized (If the request was not authenticated.)
    resource function put repositories/[string workspace]/[string repoSlug](@http:Payload Repository payload) returns Repository|RepositoryCreated|ErrorBadRequest|ErrorUnauthorized {
        return mockRepository();
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorForbidden record {|
    *http:Forbidden;
    Error body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type ErrorUnauthorized record {|
    *http:Unauthorized;
    Error body;
|};

public type ParticipantOk record {|
    *http:Ok;
    Participant body;
|};

public type PullrequestOk record {|
    *http:Ok;
    Pullrequest body;
|};

public type RepositoryCreated record {|
    *http:Created;
    Repository body;
    record {|string Location?;|} headers;
|};

public type RepositoryOk record {|
    *http:Ok;
    Repository body;
|};

# Base type for most resource objects. It defines the common `type` element that identifies an object's type. It also identifies the element as Swagger's `discriminator`
public type Error record {
    # Type of the object
    string 'type;
    # Details of the error
    ErrorDetail 'error?;
};

public type ErrorDetail record {|
    # Optional structured data that is endpoint-specific
    record {} data?;
    string detail?;
    string message;
|};
