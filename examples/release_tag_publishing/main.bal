// Tags the most recent commit of a repository as a release and lists the resulting tags.

import ballerina/io;
import ballerinax/bitbucket;

configurable string accessToken = ?;
configurable string workspace = ?;
configurable string repoSlug = ?;
configurable string tagName = ?;
configurable boolean publishTag = false;

public function main() returns error? {
    bitbucket:Client bitbucketClient = check new ({auth: {token: accessToken}});

    // Step 1: Find the most recent commit.
    bitbucket:PaginatedChangeset commits = check bitbucketClient->listCommits(repoSlug, workspace);
    bitbucket:BaseCommit[] recentCommits = commits?.values ?: [];
    if recentCommits.length() == 0 {
        return error("The repository has no commits to tag.");
    }
    string? latestHash = recentCommits[0]?.hash;
    if latestHash is () {
        return error("The latest commit has no hash.");
    }
    io:println("Latest commit: ", latestHash);

    // Step 2: Create the release tag.
    if publishTag {
        bitbucket:Tag tag = check bitbucketClient->createTag(repoSlug, workspace, {
            'type: "tag",
            name: tagName,
            target: {'type: "commit", hash: latestHash}
        });
        io:println("Created tag: ", tag?.name ?: tagName);
    } else {
        io:println("publishTag is false, skipping tag creation.");
    }

    // Step 3: List the tags of the repository.
    bitbucket:PaginatedTags tags = check bitbucketClient->listTags(repoSlug, workspace);
    foreach bitbucket:Tag existing in tags?.values ?: [] {
        io:println("Tag: ", existing?.name ?: "(unnamed)");
    }
}
