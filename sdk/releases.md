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
4. If the publish fails then add commits to the `main` branch that aim to fix the problem and then try step 3 again
5. Push Git version tag, which may or may not have a `v` prefix according to the existing conventions for this SDK repository
6. Create GitHub release

## Release Branch

- Branch from the `main` branch
- Merge to the `main` branch, once approved
- Named liked `release/<version>`
- Increment the version
- Version should conform to [SemVer](https://semver.org/)
- Add change log entry

## Publish Workflow

- Run in GitHub environment
- Publish to downstream package repositories using an Ably identity, not using an identity tied to an individual person in any way
- Use GitHub repository secrets to securely store the credentials required to publish under the Ably identity
