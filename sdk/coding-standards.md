# Coding Standards

Our preference on the SDK Team is not to publish and attempt to keep maintained code standard documents that are designed to be purely human readable.
The modern approach to conforming code formatting is to use linters and the modern approach to spotting structural issues is to use static analysis.

The purpose of this document is:

- To provide meta-documentation (very high level) around what we’re doing, and where, across our SDK estate in respect of linting and static analysis.
- To provide a canonical point of reference for rules that either cannot be applied using linting or static analysis, or which we would like to use linting or static analysis for in future.
  This should not be a massive list.

## Linting and Static Analysis

We should always aim to use the validating tools which are idiomatic for the language and platform that developers are working with.

Those tools should be run in CI and those checks passing must be a requirement for pull requests to be merged.

## Other Rules

### Boilerplate Content and Individual Attribution

Remove comment headers and unused boilerplate wherever possible before committing files.

This includes headers where your own name is included - the worst offender being Xcode’s default template file layouts.
See [this review comment](https://github.com/ably/ably-asset-tracking-swift/pull/169#discussion_r695793499) for an example.
