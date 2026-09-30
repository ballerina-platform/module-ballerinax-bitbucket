# Examples

The `ballerinax/bitbucket` connector provides practical examples illustrating usage in various scenarios.

1. [Pull request review flow](./pull_request_review_flow/pull_request_review_flow.md) - Review the open pull requests of a repository, then approve and merge one.
2. [Release tag publishing](./release_tag_publishing/release_tag_publishing.md) - Tag the latest commit of a repository as a release and list the repository tags.

## Prerequisites

* Ballerina Swan Lake 2201.12.0 or later.
* A Bitbucket Cloud access token. Each example reads it, along with the workspace and repository, from a `Config.toml` file placed in the example directory.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
