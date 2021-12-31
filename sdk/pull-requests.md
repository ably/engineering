# Ably SDK Team: Guidance on Pull Requests

We have a few locations where standards and best practices have been captured - however they rarely reflect our current practices on the SDK Team, in particular where we're working in open source.

This document is intended as a canonical reference documenting how the SDK Team prefers to process pull requests in the public domain / open source:

- It is _just_ guidance and we acknowledge that there are all sorts of reasons why individuals (people, repositories, units of work, whatever!) may need to deviate from what's laid out here (see [GitHub: Flexibility](github.md#flexibility))
- It should be read alongside wider guidance, standards and best practices defined by us for [Git](git.md) and [GitHub](github.md)
- Where the words 'must', 'should' and 'may' are used (with or without 'not') then they should be interpreted per [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119) for the avoidance of doubt - as such, cleary, flexibility and deviation from statements specifying 'must' should be carefully considered!

## General

- All PRs should be approved by at least one SDK Team member who maintains that client library
- Ideally, in most cases, PRs should be landed (merged) to the `main` branch by the Lead Engineer responsible for that client library
- Avoid publishing comments into that public domain that just represent housekeeping or reminders to other team members - these should more appropriately be handled as internal messaging over Slack (probably via the appropriate SDK repository channel)

## Merge vs Rebase

### Always Merge to Target

All pull requests **must** be landed to the target (base) branch using a merge commit.
This allows us to reliably get back to the pull request in GitHub later on.

### Flexible regarding Merge From or Rebase Atop Target

There are two schools of thought in respect of how a pull request should be curated during its lifetime.
We prefer to leave it up to individual developers to use the approach that works best for them.

- The **Merge** Approach:
  - Create a merge commit to bring in changes from the target (base) branch when that target moves
  - Add new commits to address changes needed
- The **Rebase** Approach:
  - Rebase all commits atop the target (base) branch when that target moves
  - Modify commits already in the pull request to address changes needed (squish, force push)

There are advantages in both approaches.
The pull request author should lead in respect of deciding which approach to use for any particular pull request,
however there may be times when they should consider the preferences of those who are reviewing their work.

For the lifetime of a pull request it should use the same approach throughout.

## Branch Names

All repositories use `main` as the default branch name, that is the primary long-lived branch from which releases are made.
Most pull requests will branch from that branch.

We don't want to be overly prescriptive when it comes to defining a naming convention for branches underlying pull requests, however there are a few conventions we've settled on which generally make sense for our ways of working - so, if in doubt, you should prefer to name your branches using the following prefixes:

- `feature/`: A branch containing specific or self-contained work - typically branched from `main` or an integration branch. Typically targetting a single issue, ideally with a narrow scope of work.
- `integration/`: A long-running branch on which the team can collaborate, with the intention that multiple pull requests will target it over a given period of time. Integration branches are often not intended for the next release or there are other reasons why this work needs to be kept separate from the `main` branch.
- `release/`: A branch containing the changes required to mutate the code in readiness for releasing a new version. Contributing guides in each repository detail how these should be named and used.

## Commits

### Commit Messages

There are differing opinions on how commit messages should be structured.

There are also differing opinions as to how important it is to have a 'great' conformed commit message structure (generally for historical purposes).
The definition of 'great' will vary from person to person, so our preference is to err on the side of flexibility and allow individuals to structure their commit messages in the way that they feel most comfortable working.

That said, there are still a few fundamental things which we think should be common to all good commit messages:

- They should use the **imperative, present tense**:
  - **Correct**: "Fix bug."
  - **Wrong**: "Fixed bug.", "Fixes bug."
  - This is because you or somebody else may end up doing a rebase or cherry-pick later on, in which case the commit may be outside of its original context
- They should start with a single, short line:
  - That first line should not be _too_ long, however we would rather not put an upper limit on this as the tools that render commit messages (e.g. SourceTree, GitHub UI, etc..) will change their approach over time so a static limit like 50 or 80 characters is needlessly restrictive for future settings
  - That first line should capture the essence of the change, without going into detail of how or why
  - If more detail is appropriate then the first line should be followed by a blank line and then that further detail, formatted how the author desires

We tend not to reference issues fixed by commits in the messages of those commits as our preference is to link the pull request to the issue, so that the issue gets automatically closed when the pull request lands.
