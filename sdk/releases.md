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

Should:

- branch from the `main` branch
- merge to the `main` branch, once approved
- be named like `release/<version>`
- update the version - see [Version Bump](#version-bump)
- add a change log entry (process to be documented under [#17](https://github.com/ably/engineering/issues/17))

## Publish Workflow

Should:

- run in the GitHub environment
- be written so that it is manually triggered using a [`workflow_dispatch` event](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
- override the default [checkout](https://github.com/actions/checkout) `ref` with a commit SHA supplied as an input to the triggering event, where that SHA will generally be `HEAD` of the `main` branch, at the point the [Release Branch](#release-branch) was merged
- publish to downstream package repositories using an Ably identity, not using an identity tied to an individual person in any way
- use GitHub repository secrets or ideally [GitHub OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect) (ask [@lmars](https://github.com/lmars)), to securely manage the flow of credentials required to publish under the Ably identity

## Version Bump

Should:

- conform to [SemVer](https://semver.org/)
- either:
  - increment `major`, `minor`, `patch` or the nature of the pre-release suffix (see [Product Lifecycle](product-lifecycle.md)); or
  - remove the pre-release suffix

For clarity, conforming to semantic versioning, here are example version updates for each possible bump scenario:

| Bump | Example Before | Example After | Trigger | SemVer Description | Notes |
| ---- | -------------- | ------------- | ------- | ------------------ | ----- |
| Increment `major` | `1.2.3` | `2.0.0` | Includes at least one change labelled `breaking` | [if any backwards incompatible changes are introduced to the public API](https://semver.org/#spec-item-8) | Users may need to change their code if they are using the affected APIs. |
| Increment `minor` | `1.2.3` | `1.3.0` | Includes at least one change labelled `enhancement`, and no changes labelled `breaking` | [if new, backwards compatible functionality is introduced to the public API](https://semver.org/#spec-item-7) | Also include enhancements which don't change the public API but do add or improve functionality (e.g. performance improvement). |
| Increment `patch` | `1.2.3` | `1.2.4` | Does not include any changes labelled either `enhancement` or `breaking` or both | [if only backwards compatible bug fixes are introduced](https://semver.org/#spec-item-6) |
| Increment `major`, as pre-release | `1.2.3` | `2.0.0-rc.1` | Includes at least one change labelled `breaking` | [if any backwards incompatible changes are introduced to the public API](https://semver.org/#spec-item-8) | Users may need to change their code if they are using the affected APIs. |
| Increment `minor`, as pre-release | `1.2.3` | `1.3.0-rc.1` | Includes at least one change labelled `enhancement`, and no changes labelled `breaking` | [if new, backwards compatible functionality is introduced to the public API](https://semver.org/#spec-item-7) | Also include enhancements which don't change the public API but do add or improve functionality (e.g. performance improvement). |
| Increment `patch`, as pre-release | `1.2.3` | `1.2.4-rc.1` | Does not include any changes labelled either `enhancement` or `breaking` or both | [if only backwards compatible bug fixes are introduced](https://semver.org/#spec-item-6) |
| Increment nature of pre-release suffix | `2.0.0-beta.2` | `2.0.0-rc.1` | We want to remain in pre-release, but our level of confidence has increased so we're upgrading the phase. |
| Increment 'build' numeric component of pre-release suffix | `2.0.0-rc.1` | `2.0.0-rc.2` | We want to remain in pre-release and our level of confidence remains the same, we've just iterated/improved. |
| Remove pre-release suffix | `2.0.0-rc.2` | `2.0.0` | We're ready to move to GA for this release. | | Has implications for scope of changelog entry. See [this comment](https://github.com/ably/engineering/issues/17#issuecomment-1310626521). |

See: [GitHub Standards and Best Practices: Labels](github.md#labels)

"Trigger" analysis must include labels assigned to pull requests.
It should also include labels assigned to issues linked to those pull requests.

"Public API" only refers to the interfaces that users code against to use our SDKs.
Therefore, SDK changes to the Ably REST or Realtime protocol implementation do not always necessitate a `major` version bump - that is, those changes may not need to be labelled `breaking`, unless they _also_ change the user-facing APIs offered by the SDK in a backwards incompatible manner.

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
