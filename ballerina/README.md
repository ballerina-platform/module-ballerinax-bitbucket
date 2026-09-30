# Ballerina Bitbucket connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-bitbucket/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-bitbucket.svg)](https://github.com/ballerina-platform/module-ballerinax-bitbucket/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/bitbucket.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fbitbucket)

## Overview

The Bitbucket connector lets Ballerina integrations work with [Bitbucket Cloud](https://bitbucket.org/), Atlassian's Git repository hosting and collaboration service, through version 2.0 of its REST API. It covers the API's full operation surface, including repositories, branches and tags, commits, pull requests, pipelines, snippets, projects, workspaces and permissions, so that source-control and CI/CD workflows can be automated from a Ballerina program.

### Key features

* Create, update and delete repositories, branches, tags and branch restriction rules.
* Open, review, approve and merge pull requests, and read their activity and comments.
* Browse commits, diffs, source files and commit statuses.
* Manage Bitbucket Pipelines, including variables, schedules, runners and caches.
* Administer workspaces, projects, members and permissions.
* Share code with snippets and manage SSH and GPG keys.

## Setup guide

To use the connector you need a Bitbucket Cloud account and one of the supported credentials.

1. Sign in to [Bitbucket Cloud](https://bitbucket.org/) and open the workspace, project or repository you want to automate.
2. Create an access token. Open the repository (or workspace) **Settings**, choose **Access tokens** and create a token with the scopes your integration needs, such as repository read and write, and pull request read and write.
3. Copy the token. It is shown only once.
4. Alternatively, authenticate with your Bitbucket username and an app password, or with an OAuth 2.0 consumer created under **Workspace settings > OAuth consumers**.
5. Keep the credentials in a `Config.toml` file next to your program and never commit them to source control.

## Quickstart

1. Import the connector.

    ```ballerina
    import ballerinax/bitbucket;
    ```

2. Add the credentials to `Config.toml`.

    ```toml
    accessToken = "<your-access-token>"
    ```

3. Create the client.

    ```ballerina
    configurable string accessToken = ?;

    bitbucket:Client bitbucketClient = check new ({auth: {token: accessToken}});
    ```

4. Call an operation, for example fetch the authenticated user, and run the program with `bal run`.

    ```ballerina
    public function main() returns error? {
        bitbucket:Account _ = check bitbucketClient->getCurrentUser();
    }
    ```

## Examples

The `Bitbucket` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-bitbucket/tree/main/examples/), covering the following use cases:

* [pull_request_review_flow](../examples/pull_request_review_flow/pull_request_review_flow.md) - Review the open pull requests of a repository, then approve and merge one.
* [release_tag_publishing](../examples/release_tag_publishing/release_tag_publishing.md) - Tag the latest commit of a repository as a release and list the repository tags.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`bitbucket` package](https://central.ballerina.io/ballerinax/bitbucket/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
