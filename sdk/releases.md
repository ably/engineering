# Ably SDK Team: Guidance on Releases

This document outlines our ideal requirements for SDK releases.

There will be some SDK repositories:

- which are yet to have the work done on them which will implement this
- where it's necessary to deviate from some of the ideals specified here due to constraints which are innate or otherwise idiomatic to the platform being released for

Where technically possible, SDK repository release processes which claim to adhere to this guidance must follow these ideal requirements closely.

## Release Process

1. Merge all pull requests containing changes intended for this release to `main` branch
2. Prepare a [Release Branch](#release-branch) and a corresponding pull request, obtain approval from reviewers and then merge to `main` branch
3. Trigger the [Publish Workflow](#publish-workflow)
4. If the publish fails then fix the state of the `main` branch, via one or more approved pull requests, with focussed changes that aim to fix the problem and then try step 3 again
5. Push Git [Version Tag](#version-tag)
6. Create GitHub release

## Release Branch

- Branch from the `main` branch
- Merge to the `main` branch, once approved
- Named like `release/<version>`
- Increment the version
- Version should conform to [SemVer](https://semver.org/)
- Add change log entry (process to be documented under [#17](https://github.com/ably/engineering/issues/17))

## Publish Workflow

- Run in GitHub environment
- Be written so that it is manually triggered using a [`workflow_dispatch` event](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- Override the default [checkout](https://github.com/actions/checkout) `ref` with a commit SHA supplied as in input to the triggering event, where that SHA will generally be `HEAD` of the `main` branch, at the point the [Release Branch](#release-branch) was merged
- Publish to downstream package repositories using an Ably identity, not using an identity tied to an individual person in any way
- Use GitHub repository secrets or ideally [GitHub OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect) (ask [@lmars](https://github.com/lmars)), to securely manage the flow of credentials required to publish under the Ably identity

## Version Tag

Should:

- have a `v` prefix - e.g. `v1.2.3` for the release of version `1.2.3`
- be pushed after the release has been published to downstream package repositories
- be made against the commit against which the [Publish Workflow](#publish-workflow) was successfully run
- not be subsequently moved

Additional Notes:

- This guidance relates to the fully qualified, [semantically versioned](https://semver.org/) tags that represent a specific release,
  which is why these tags should not be subsequently moved once they have been pushed.
  There are conventions around additional, moveable tags tracking major (e.g. `v1`) and minor (e.g. `v1.2`) releases which are used by some ecosystems (e.g. [GitHub Actions](https://docs.github.com/en/actions/creating-actions/releasing-and-maintaining-actions)), but we don't use those conventions or moveable tags for our SDK releases, therefore they're not in scope of this document.
- For historical reasons, we have some SDK repositories which have version tags that do not have the `v` prefix.
  Where possible, these repositories should be migrated to conform to the format specified here, including the `v` prefix.
  Any such migration should:
  - leave existing tags where they are
  - add new tags, aligned to the same commit as the existing tags, with the `v` prefix
  - update release procedures and any related tooling to make it clear that the `v` prefix is required
