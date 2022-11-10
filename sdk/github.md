# Ably SDK Team: GitHub Standards and Best Practices

This document details how the SDK Team at Ably uses GitHub.
The goal is to conform, where possible, so that as developers move from repository to repository the experience is predictable and unsurprising.

The standards and best practices documented on this page are intended to be:

- As lightweight as possible, because:
  - We work daily with contributors from all sorts of backgrounds - experience and daily context differ from person to person, so it's not helpful to require people to read loads of text in order to start working with us
  - Where something is _really_ important to us then we'll put in place a mechanism that automatically checks it (e.g. tests or a lint tool) - this generally enables us to avoid [bike-shedding](https://en.wikipedia.org/wiki/Law_of_triviality)
- Interpreted as _guidance_, based on our experience as a team:
  - These are not policies or rules - yes, deviation _might_ be frowned upon by others, but equally experimentation can lead to innovation - we are agile and need to iterate and evolve
  - We should be as inclusive as possible, therefore we all accept that 'life happens' and deviation from 'the norm' is acceptable

## GitHub First

On first inspection, for those granted access to Ably's internal systems, it can be a little bit confusing that we have two ticket / issue management systems in concurrent use for our client libraries (GitHub issues and Jira).
They complement each other and this section aims to explain why.

One of our key company [values](https://ably.com/blog/ably-values) is being **open for all**.
Our client library codebases align with this value as they are open source, available to view in every detail in the public domain.

### GitHub...

Allows external parties to contribute by:

- creating issues for bugs they’ve found or enhancements they would like to see
- creating pull requests to fix bugs or suggest improvements
- commenting on issues and pull requests
- reacting to comments
- starring our repositories
- watching our repositories
- forking our repositories

Allows us to:

- work on fixing bugs and writing enhancements in the public domain using pull requests, for all to see
- communicate our desires and known bugs and limitations by way of issues

### Jira...

Used for internal management.

GitHub issues are [bidirectionally synchronised with Jira](https://ably.atlassian.net/wiki/spaces/DEL/pages/996114441).

Jira allows us to add internal meta-information beyond what GitHub issues allow us to - this includes:

- backlog prioritisation
- status (todo > in progress > in review > done; etc..)

### ...GitHub first!

Generally the following operations should be performed from GitHub, not Jira (unless they are issues which solely exist in Jira):

- creating issues
- commenting on issues
- closing issues

The primary reason is that this uses your real GitHub identity to associate with the operation from a public domain perspective.
Operations done from Jira sync over to GitHub using a bot account and that looks ugly and awkward for external viewers.

## Repository Names

The convention at Ably is to name repositories in the `ably` GitHub org that contain the source code for a client library / SDK with an `ably-` prefix.
For example, `ably/ably-js`, where `ably` is the org and `ably-js` is the repository name.

## Pull Requests

See [Pull Requests](pull-requests.md) for guidance around how we work on PRs in open source.

## Workflows

This section describes our ways of working with GitHub workflows.

GitHub documents them under the umbrella of GitHub Actions, which has resulted in 'Actions' somewhat incorrectly being adopted as the all-encompassing title for this technology.
The reality is that an Action is _just_ a component of this technology stack, a thing that is downloaded and invoked by workflows (see [`jobs.<job_id>.steps[*].uses` in the syntax for workflows](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idstepsuses)).

### Filenames

This is the name of the file within the `.github/workflows` folder.

- Should have a `yaml` extension
- Should be all in lowercase
- Should use one of our standard names unless they’re not suited. Standard names and their purposes are as follows:
  - `assemble`:
    - build the project (archives / artifacts)
    - for Gradle Java projects this is `./gradlew assemble`
    - pushes artifacts, where logical, to `sdk.ably.com` (staging)
  - `check` - for basic, quick verification tasks, including:
    - run linters
    - perform static analysis if available
    - run unit tests
    - generate code coverage reports from unit test runs if possible (probably uploaded as [artifacts](https://docs.github.com/en/actions/advanced-guides/storing-workflow-data-as-artifacts))
    - for Gradle Java projects this is `./gradlew check`
    - should not run time consuming integration tests
    - examples:
      [ably-asset-tracking-android](https://github.com/ably/ably-asset-tracking-android/blob/main/.github/workflows/check.yml),
      [ably-java](https://github.com/ably/ably-java/blob/main/.github/workflows/check.yml),
      [ably-js](https://github.com/ably/ably-js/blob/main/.github/workflows/check.yml),
      [engineering](https://github.com/ably/engineering/blob/main/.github/workflows/check.yaml)
  - `docs`:
    - build API reference documentation from interface commentary
    - should push artifacts to `sdk.ably.com` (staging)
    - examples:
      [ably-asset-tracking-android](https://github.com/ably/ably-asset-tracking-android/blob/main/.github/workflows/docs.yml),
      [ably-asset-tracking-swift](https://github.com/ably/ably-asset-tracking-swift/blob/main/.github/workflows/docs.yml),
      [ably-flutter](https://github.com/ably/ably-flutter/blob/main/.github/workflows/docs.yml)
  - `emulate`:
    - runs tests, typically time consuming integration tests
    - spawns an emulator to do the testing - typically Android or iOS
    - for Gradle Java projects this is `./gradlew connectedCheck`
    - example:
      [ably-asset-tracking-android](https://github.com/ably/ably-asset-tracking-android/blob/main/.github/workflows/emulate.yml)
  - `integration-test`:
    - run time consuming integration tests
    - may use a matrix strategy to run tests across different runtime variants (e.g. by type or version)
    - may have a arbitrarily named suffix specific to a particular runtime variant or set of runtime variants:
      - delimited by a dash (`-`)
      - this means that multiple workflow files can have the prefix `integration-test-`
      - this approach is sometimes preferable to putting all tests in a matrix in a single workflow due to a limitation in GitHub's interface where all jobs have to be triggered to start, or re-run, for any single one of them to run (meaning unnecessary overhead when only one suite is failing)
    - example:
      [ably-java](https://github.com/ably/ably-java/blob/main/.github/workflows/integration-test.yml),
      [ably-js (node)](https://github.com/ably/ably-js/blob/main/.github/workflows/test-node.yml) [to be renamed],
      [ably-js (playwright)](https://github.com/ably/ably-js/blob/main/.github/workflows/test-playwright.yml) [to be renamed]
  - `publish`:
    - builds and then pushes the built product out to external package distribution repository(s)
    - must be a manually triggered workflow
    - should take version as input, so that it can run against a git tag (pushed as a prior step in the release process)
    - examples:
      [ably-asset-tracking-android](https://github.com/ably/ably-asset-tracking-android/blob/main/.github/workflows/publish.yml),
      [ably-common](https://github.com/ably/ably-common/blob/main/.github/workflows/publish.yml)
  - `report`:
    - generates reports on the code and/or build which are ancillary to the core product build
    - example:
      [ably-js](https://github.com/ably/ably-js/blob/main/.github/workflows/bundle-report.yml) [to be renamed]

### Names

#### Name vs Filename

The root `name` key, typically defined at the top of the workflow file, should match the file name with:

- Dashes replaced with spaces
- The first letter of each word capitalised
- Dashes preceding a variant suffix replaced by a colon and a space (`': '`)

Examples:

- `Check` for `check.yaml`
- `Integration Test` for `integration-test.yaml`
- `"Integration Test: Node"` for `integration-test-node.yaml` (double quotes needed in this case for YAML to specify a string definition)

#### Some History re Workflow Names

The `name` key, at the top of the workflow file, [is defined as optional](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#name).

When we started using workflows, we took the decision to take advantage of this optionality and not define the root `name` for workflow files, due to the fact that it generally seemed to just repeat the name of the file.
More recently, we've come to realise that the GitHub user interface will use this name to represent workflows in a much more concise and human readable form.
When omitted, the full path to the workflow is used and this is ugly (for example: as `.github/workflows/check.yaml` in the 'Actions' tab of a repository).

### Triggers (`on:`)

Unless there a good reason to deviate from this, workflows should always be configured to trigger as follows:

```yml
on:
  pull_request:
  push:
    branches:
      - main
```

### Job Names

This one’s a work in progress at the moment.
If in doubt use `check`.
We’re also using `build` in some places (e.g. Android Asset Tracking’s [docs workflow](https://github.com/ably/ably-asset-tracking-android/blob/main/.github/workflows/docs.yml)), where the job’s purpose is generating built output that’s intended to be accessible beyond the lifespan of the workflow.

It’s important because when we create branch protection rules (typically for the default branch, `main`) we want to tick the box to “Require status checks to pass before merging”, which then presents us a list of job names under “Status checks found in the last week for this repository”.

### Matrix Strategies

By default GitHub’s [fail-fast](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idstrategyfail-fast) property on strategies is set to `true`.
While that might be kinder from GitHub's perspective on their server resources, as jobs will get cancelled prematurely, it doesn't help us debug when things go wrong.
So, generally, our preference is to override the default and explicitly specify `false` for `fail-fast`.

It’s [a growing trend across our org](https://github.com/search?q=org%3Aably+fail-fast&type=code). :smiling_imp:

## Actions

To support our workflows we’re developing our own Actions - the LEGO-like modules that allow us to build build ourselves bigger structures from proven components of functionality.

### SDK Upload Action

[ably/sdk-upload-action](https://github.com/ably/sdk-upload-action)

Pushing artifacts to [sdk.ably.com](http://sdk.ably.com/) (see [this internal page](https://ably.atlassian.net/wiki/spaces/SDK/pages/1191804978) for more information on the S3 bucket that underlies this domain).

## Deployments and Environments

The [docs repository](https://github.com/ably/docs) has been using these for a while, with its own naming convention for [environments](https://github.com/ably/docs/deployments).

The SDK Team are also evolving a naming convention for environments. Initially modelled in [ably-flutter #92](https://github.com/ably/ably-flutter/pull/97),
tied in with the [SDK Upload Action](https://github.com/ably/sdk-upload-action).

## Labels

The following table canonically defines labels we use in common across our open source SDK repositories:

| Name | Color | Description | Additional Notes |
| ---- | ----------- | ----- | ---------------- |
| `blocked-by-ably` | ![fbca04](https://img.shields.io/badge/-fbca04-fbca04) | We can't proceed until something under our direct control, in a different codebase, happens. | Comments should be added to indicate what the blockage is (e.g. another SDK repository). |
| `blocked-by-external` | ![fbca04](https://img.shields.io/badge/-fbca04-fbca04) | We can't proceed until something outside of Ably's direct control happens. | Comments should be added to indicate what the blockage is. |
| `bug` | ![d73a4a](https://img.shields.io/badge/-d73a4a-d73a4a) | Something isn't working. It's clear that this does need to be fixed. | Usually implies that related changes can be released in a `patch` version bump. |
| `breaking` | ![ec4b42](https://img.shields.io/badge/-ec4b42-ec4b42) | Affects the developer experience when working in our codebase. | Implies a need to release related changes in a `major` version bump. |
| `code-quality` | ![ff88cc](https://img.shields.io/badge/-ff88cc-ff88cc) | Affects the developer experience when working in our codebase. |
| `documentation` | ![0075ca](https://img.shields.io/badge/-0075ca-0075ca) | Improvements or additions to public interface documentation (API reference or readme). |
| `enhancement` | ![a2eeef](https://img.shields.io/badge/-a2eeef-a2eeef) | New feature or request. | Implies a need to release related changes in a `minor` version bump. |
| `example-app` | ![70fc6b](https://img.shields.io/badge/-70fc6b-70fc6b) | Relates to the example apps included in this repository. | Not all repositories have embedded example apps. |
| `failing-test` | ![ff8888](https://img.shields.io/badge/-ff8888-ff8888) | Where a test is failing either locally or in CI. Perhaps flakey (badly written), wrong or bug. |
| `testing` | ![ff8888](https://img.shields.io/badge/-ff8888-ff8888) | Includes all kinds of tests, the way that we run tests and test infrastructure. |

The _Name_, _Color_ and _Description_ values above should be used when creating the corresponding labels in repositories.

It is expected that some labels will be used together - for example `enhancement` and `breaking`, indicating a feature that's been added in a way that introduces backwards incompatible changes into the public API, therefore implying the need to release in a `major` (_not_ `minor`) version bump.

While GitHub does allow us to use mixed case and spaces in label names, we've restricted ourselves to all lowercase and dashes instead of spaces to separate words.

We do not have any labels that imply or otherwise infer importance or prioritisation of issues or pull requests because that information is internally managed using Jira (see [GitHub First](#github-first)).

## Flexibility

### What things we're flexible about

Things that the Ably SDK Team, in the open source work that we facilitate, _intentionally_ **don't** require contributors to do:

- Format commit messages in a particular style
- Conform to a naming convention for feature branches

### Why we're flexible about some things

So, why do we leave some things flexible and up to individual preference?

Primarily, as stated at the start of this page, we - as a team - learn from _experience_.
This means that there are things we end up converging on, as best practices or standards, because they've been shown to be sensible things to do in order to enable our work to progress productively and predictably for everybody involved.
We, therefore, feel it's worthwhile sharing those things as standards and best practices on this page.

However, conversely, there are things that - again, based on our experience - haven't been shown to matter that much.
More often, it turns out that many of these things are somewhat subjective in nature.
We don't feel it's necessary to mandate rules or policies around these things as, on balance, we would prefer to tip the balance in these areas to allow individuals to express themselves with the work that they do in the way that they feel most comfortable.

We're not machines. We're humans. Let's keep this fun!

## See Also

- [Ably Repository Audit Tool](https://github.com/ably/repository-audit)
