# Ably SDK Team: GitHub Standards and Best Practices

This document details how the SDK Team at Ably uses GitHub.
The goal is to conform, where possible, so that as developers move from repository to repository the experience is predictable and unsurprising.

The standards and best practices documented on this page are intended to be:

- As lightweight as possible, because:
  - We work daily with contributors from all sorts of backgrounds - experience and daily context differ from person to person, so it's not helpful to require people to read loads of text in order to start working with us
  - Where something is _really_ important to us then we'll put in place a mechanism that automatically checks it (e.g. tests or a lint tool) - this generally enables us to avoid [bike-shedding](https://en.wikipedia.org/wiki/Law_of_triviality)
- Interpreted as _guidance_, based on our experience as a team:
  - These are not policies or rules - yes, deviation _might__ be frowned upon by others, but equally experimentation can lead to innovation - we are agile and need to iterate and evolve
  - We should be as inclusive as possible, therefore we all accept that 'life happens' and deviation from 'the norm' is acceptable

## GitHub First

On first inspection, for those granted access to Ably's internal systems, it can be a little bit confusing that we have two ticket / issue management systems in concurrent use for our client libraries (GitHub issues and Jira).
They complement each other and this page aims to explain why.

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

Generally the following operations should be performed from GitHub, not Jira:

- creating issues
- commenting on issues

The primary reason is that this uses your real GitHub identity to associate with the operation from a public domain perspective.
Operations done from Jira sync over to GitHub using a bot account and that looks ugly and awkward for external viewers.

## Pull Requests

See [Pull Requests](pull-requests.md) for guidance around how we work on PRs in open source.

## Workflows

This section describes our ways of working with GitHub workflows.

GitHub documents them under the umbrella of GitHub Actions, which has resulted in 'Actions' somewhat incorrectly being adopted as the all-encompassing title for this technology.
The reality is that an Action is _just_ a component of this technology stack, a thing that is downloaded and invoked by workflows (see [`jobs.<job_id>.steps[*].uses` in the syntax for workflows](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idstepsuses)).

### Filenames

This is the name of the file within the `.github/workflows` folder.

- Will always have a `yml` extension
- Should use one of our standard names unless they’re not suited. Standard names and their purposes are as follows:
  - `assemble`:
    - build the project (archives / artifacts)
    - for Gradle Java projects this is `./gradlew assemble`
  - `check` - for verification tasks, including:
    - run linters
    - perform static analysis if available
    - run unit tests
    - generate code coverage reports from unit test runs if possible (probably uploaded as [artifacts](https://docs.github.com/en/actions/advanced-guides/storing-workflow-data-as-artifacts))
    - for Gradle Java projects this is `./gradlew check`
  - `emulate`:
    - for Gradle Java projects this is `./gradlew connectedCheck`

### Names

The `name` key, at the top of the workflow file, [is defined as optional](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#name).
Given that most workflow files usually end up repeating the filename for this key, we’re not defining it in our workflow files.

_This does reduce repetition in the workflow source code files, but does have other impacts - for example in terms of status badge presentation, so we may change this policy at some point._

### Triggers (`on:`)

Unless there a good reason to deviate from this, workflows should always be configured to trigger as follows:

```yml
on:
  pull_request:
  push:
    branches:
      - main
```

_We do have one repository which is experimenting with cron schedule (see [here](https://github.com/ably/ably-flutter/blob/36b604fdaed87342edc2fd0c9ad94c34d362148d/.github/workflows/check.yaml#L6)) but this is an exception and should not be adopted elsewhere without wider conversation and consideration._
_It’s debatable whether periodic testing of codebases should be configured at repository level - or if it is done there then perhaps it should be a discrete workflow._
_It adds a lot of noise with little obvious benefit._

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

We are slowly converging on a set of labels that are useful for our context and these are being duplicated across client libraries when needed.
This list is canonically defined [here](https://github.com/ably/ably-common/blob/main/github/labels.yml).

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
