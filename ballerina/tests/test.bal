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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.bitbucket.org/2.0" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("BITBUCKET_ACCESS_TOKEN") : "test_token";
final string workspace = isLiveServer ? os:getEnv("BITBUCKET_WORKSPACE") : "acme";
final string repoSlug = isLiveServer ? os:getEnv("BITBUCKET_REPO_SLUG") : "demo-repo";

final Client bitbucket = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

// Mutating operations run only against the mock server.

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCurrentUser() returns error? {
    Account account = check bitbucket->getCurrentUser();
    test:assertTrue(account?.display_name !is ());
}

@test:Config {groups: ["mock_tests"]}
function testGetUser() returns error? {
    Account account = check bitbucket->getUser("alex");
    test:assertEquals(account?.display_name, "Alex Morgan");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetWorkspace() returns error? {
    Workspace ws = check bitbucket->getWorkspace(workspace);
    test:assertTrue(ws?.slug !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListProjectsInWorkspace() returns error? {
    PaginatedProjects projects = check bitbucket->listProjectsInWorkspace(workspace);
    test:assertTrue(projects?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreateProjectInWorkspace() returns error? {
    if isLiveServer {
        return;
    }
    Project project = check bitbucket->createProjectInWorkspace(workspace, {'type: "project", name: "Demo Project", 'key: "DEMO"});
    test:assertEquals(project.'key, "DEMO");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetRepository() returns error? {
    Repository repo = check bitbucket->getRepository(repoSlug, workspace);
    test:assertTrue(repo?.full_name !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreateRepository() returns error? {
    if isLiveServer {
        return;
    }
    Repository repo = check bitbucket->createRepository("demo-repo", workspace, {'type: "repository", scm: "git", is_private: true});
    test:assertEquals(repo?.name, "demo-repo");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateRepository() returns error? {
    if isLiveServer {
        return;
    }
    Repository repo = check bitbucket->updateRepository("demo-repo", workspace, {'type: "repository", description: "Demo repository"});
    test:assertEquals(repo?.description, "Demo repository");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteRepository() returns error? {
    if isLiveServer {
        return;
    }
    Repository repo = check bitbucket->createRepository("scratch-repo", workspace, {'type: "repository"});
    test:assertTrue(repo?.uuid !is ());
    check bitbucket->deleteRepository("scratch-repo", workspace);
}

@test:Config {groups: ["mock_tests"]}
function testCreateBranch() returns error? {
    if isLiveServer {
        return;
    }
    Branch branch = check bitbucket->createBranch(repoSlug, workspace);
    test:assertEquals(branch?.name, "feature/orders");
}

@test:Config {groups: ["mock_tests"]}
function testGetBranch() returns error? {
    Branch branch = check bitbucket->getBranch("feature/orders", repoSlug, workspace);
    test:assertEquals(branch?.name, "feature/orders");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteBranch() returns error? {
    if isLiveServer {
        return;
    }
    Branch branch = check bitbucket->createBranch(repoSlug, workspace);
    test:assertTrue(branch?.name !is ());
    check bitbucket->deleteBranch("feature/orders", repoSlug, workspace);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTags() returns error? {
    PaginatedTags tags = check bitbucket->listTags(repoSlug, workspace);
    test:assertTrue(tags?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreateTag() returns error? {
    if isLiveServer {
        return;
    }
    Tag tag = check bitbucket->createTag(repoSlug, workspace, {'type: "tag", name: "v1.0.0", target: {'type: "commit", hash: "e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4"}});
    test:assertEquals(tag?.name, "v1.0.0");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListCommits() returns error? {
    PaginatedChangeset commits = check bitbucket->listCommits(repoSlug, workspace);
    test:assertTrue(commits?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testGetCommit() returns error? {
    Commit c = check bitbucket->getCommit("e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4", repoSlug, workspace);
    test:assertEquals(c?.hash, "e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListPullRequests() returns error? {
    PaginatedPullrequests prs = check bitbucket->listPullRequests(repoSlug, workspace);
    test:assertTrue(prs?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreatePullRequest() returns error? {
    if isLiveServer {
        return;
    }
    Pullrequest pr = check bitbucket->createPullRequest(repoSlug, workspace, {'type: "pullrequest", title: "Add order processing service"});
    test:assertEquals(pr?.title, "Add order processing service");
}

@test:Config {groups: ["mock_tests"]}
function testGetPullRequest() returns error? {
    Pullrequest pr = check bitbucket->getPullRequest(42, repoSlug, workspace);
    test:assertEquals(pr?.id, 42);
}

@test:Config {groups: ["mock_tests"]}
function testApprovePullRequest() returns error? {
    if isLiveServer {
        return;
    }
    Participant participant = check bitbucket->approvePullRequest(42, repoSlug, workspace);
    test:assertEquals(participant?.approved, true);
}

@test:Config {groups: ["mock_tests"]}
function testMergePullRequest() returns error? {
    if isLiveServer {
        return;
    }
    Pullrequest? merged = check bitbucket->mergePullRequest(42, repoSlug, workspace, {'type: "pullrequest_merge_parameters", merge_strategy: "squash"});
    test:assertEquals(merged?.state, "MERGED");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListBranchRestrictions() returns error? {
    PaginatedBranchRestrictions restrictions = check bitbucket->listBranchRestrictions(repoSlug, workspace);
    test:assertTrue(restrictions?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreateBranchRestrictionRule() returns error? {
    if isLiveServer {
        return;
    }
    BranchRestriction rule = check bitbucket->createBranchRestrictionRule(repoSlug, workspace, {'type: "branchrestriction", kind: "push", branch_match_kind: "glob", pattern: "main"});
    test:assertEquals(rule.pattern, "main");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListPipelines() returns error? {
    PaginatedPipelines pipelines = check bitbucket->listPipelines(workspace, repoSlug);
    test:assertTrue(pipelines?.values !is ());
}

@test:Config {groups: ["mock_tests"]}
function testCreateSnippet() returns error? {
    if isLiveServer {
        return;
    }
    Snippet snippet = check bitbucket->createSnippet({'type: "snippet", title: "Retry helper"});
    test:assertEquals(snippet?.title, "Retry helper");
}
