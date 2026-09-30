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

function mockAccount() returns Account => {
    "type": "user",
    uuid: "{5f1c2d3e-8a4b-4c6d-9e0f-1a2b3c4d5e6f}",
    display_name: "Alex Morgan",
    created_on: "2023-04-12T09:30:00.000000+00:00"
};

function mockProject() returns Project => {
    "type": "project",
    uuid: "{9a8b7c6d-5e4f-4321-8fed-cba987654321}",
    'key: "DEMO",
    name: "Demo Project",
    description: "Sample project used for integration demos",
    is_private: true,
    created_on: "2023-05-01T10:00:00.000000+00:00",
    updated_on: "2024-01-15T08:45:00.000000+00:00"
};

function mockRepository() returns Repository => {
    "type": "repository",
    uuid: "{c3d4e5f6-1a2b-4c3d-8e9f-0a1b2c3d4e5f}",
    full_name: "acme/demo-repo",
    name: "demo-repo",
    description: "Demo repository",
    is_private: true,
    scm: "git",
    language: "ballerina",
    size: 2048,
    has_issues: true,
    has_wiki: false,
    fork_policy: "no_public_forks",
    created_on: "2023-06-01T12:00:00.000000+00:00",
    updated_on: "2024-02-20T16:20:00.000000+00:00",
    owner: mockAccount(),
    project: mockProject()
};

function mockCommit() returns Commit => {
    "type": "commit",
    hash: "e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4",
    date: "2024-02-20T16:20:00+00:00",
    message: "Add order processing service",
    author: {"type": "author", raw: "Alex Morgan <alex@example.com>"}
};

function mockBranch() returns Branch => {
    "type": "branch",
    name: "feature/orders",
    target: mockCommit(),
    merge_strategies: ["merge_commit", "squash"],
    default_merge_strategy: "merge_commit"
};

function mockTag() returns Tag => {
    "type": "tag",
    name: "v1.0.0",
    message: "First stable release",
    date: "2024-03-01T10:00:00+00:00",
    target: mockCommit()
};

function mockPullRequest() returns Pullrequest => {
    "type": "pullrequest",
    id: 42,
    title: "Add order processing service",
    state: "OPEN",
    author: mockAccount(),
    comment_count: 3,
    task_count: 1,
    close_source_branch: true,
    draft: false,
    created_on: "2024-02-21T09:00:00.000000+00:00",
    updated_on: "2024-02-22T11:30:00.000000+00:00"
};

function mockBranchRestriction() returns BranchRestriction => {
    "type": "branchrestriction",
    id: 7,
    kind: "push",
    branch_match_kind: "glob",
    pattern: "main"
};

function mockSnippet() returns Snippet => {
    "type": "snippet",
    id: 1001,
    title: "Retry helper",
    scm: "git",
    is_private: true,
    created_on: "2024-01-10T07:00:00.000000+00:00",
    updated_on: "2024-01-11T07:00:00.000000+00:00",
    owner: mockAccount(),
    creator: mockAccount()
};

function mockWorkspace() returns Workspace => {
    "type": "workspace",
    uuid: "{1b2c3d4e-5f60-4718-92a3-b4c5d6e7f809}",
    name: "Acme",
    slug: "acme",
    is_private: true,
    created_on: "2022-11-01T08:00:00.000000+00:00"
};
