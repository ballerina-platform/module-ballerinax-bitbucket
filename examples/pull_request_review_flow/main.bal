// Reviews the open pull requests of a repository and optionally approves and merges one of them.

import ballerina/io;
import ballerinax/bitbucket;

configurable string accessToken = ?;
configurable string workspace = ?;
configurable string repoSlug = ?;
configurable int pullRequestId = ?;
configurable boolean approveAndMerge = false;

public function main() returns error? {
    bitbucket:Client bitbucketClient = check new ({auth: {token: accessToken}});

    // Step 1: List the open pull requests of the repository.
    bitbucket:PaginatedPullrequests openPullRequests = check bitbucketClient->listPullRequests(repoSlug, workspace, state = "OPEN");
    bitbucket:Pullrequest[] pullRequests = openPullRequests?.values ?: [];
    io:println("Open pull requests: ", pullRequests.length());

    // Step 2: Fetch the pull request selected for review.
    bitbucket:Pullrequest pullRequest = check bitbucketClient->getPullRequest(pullRequestId, repoSlug, workspace);
    io:println("Reviewing #", pullRequestId, ": ", pullRequest?.title ?: "(untitled)");

    if !approveAndMerge {
        io:println("approveAndMerge is false, skipping approval and merge.");
        return;
    }

    // Step 3: Approve the pull request.
    bitbucket:Participant approval = check bitbucketClient->approvePullRequest(pullRequestId, repoSlug, workspace);
    io:println("Approved: ", approval?.approved ?: false);

    // Step 4: Merge the pull request.
    bitbucket:Pullrequest? merged = check bitbucketClient->mergePullRequest(pullRequestId, repoSlug, workspace, {'type: "pullrequest_merge_parameters", close_source_branch: true});
    if merged is bitbucket:Pullrequest {
        io:println("Merged, state: ", merged?.state ?: "UNKNOWN");
    } else {
        io:println("Merge accepted and is being processed asynchronously.");
    }
}
