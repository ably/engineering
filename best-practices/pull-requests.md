# Ably Engineering Team: Guidance on Pull Requests

This document is intended as a canonical reference documenting how we prefer to process pull requests in the public domain / open source:

- It is _just_ guidance and we acknowledge that there are all sorts of reasons why individuals (people, repositories, units of work, whatever!) may need to deviate from what's laid out here (see [GitHub: Flexibility](github.md#flexibility))
- It should be read alongside wider guidance, standards and best practices defined by us for [Git](git.md) and [GitHub](github.md)
- Where the words 'must', 'should' and 'may' are used (with or without 'not') then they should be interpreted per [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119) for the avoidance of doubt - as such, flexibility and deviation from statements specifying 'must' should be carefully considered!

## Overview

Github Pull Requests (PRs) are the way that we review, discuss and approve the changes we make to code in our repositories.

It is important that PRs are done well because this impacts the quality of the review that can take place - which in turn determines the quality of the resulting code changes - and also because good PR structure is instrumental in achieving a high quality history once the changes are landed. PRs can only be done well when all of the participants - authors, reviewers and maintainers - each do their part effectively.

The policy here is the set of rules we use with that aim. Although there is a lot of detail here, and in the referenced documents, the emphasis in applying this policy is to understand the key principles and their motivation, rather than strictly and blindly to apply a set of regulations. The overriding philosophy is that PRs are to help us **get stuff done** whilst **improving objective quality** of the codebase they apply to. Therefore, important principles in what follows are:

- the approval of a maintainer via a PR approval is a necessary condition for new code to be merged;
- PR reviews should be conducted in a timely way so as not to impede the authors' work;
- PR feedback must be courteous, objective and clear, and should include guidance, suggestions and other constructive feeback where this helps to move everyone's work forward.

## Applicability

Every Ably repo has a set of maintainers, who are the authority for the merging of PRs into the repo. A repository's maintainers are the individuals that 'own' that repository: they are (jointly and severally) responsible for the condition of the code in it, and any maintainer can authorize code to be merged. This will generally be a much smaller set than the number of people who regularly contribute to it; repositories will generally have between one and three maintainers.

Every repository should have a MAINTAINERS file in the root. This should contain the names of the repo maintainers, one per line (optionally also their github username if that isn't obviously correlated to their name).

The approval of a maintainer is a necessary condition for new code to be merged. When creating a PR, a contributor must include at least one maintainer in the the set of reviewers they nominate. (The maintainer may of course delegate their authority by untagging themselves and/or tagging someone else, either another maintainer or a non-maintainer, according to their judgement). An exception to this rule is that, the maintainer of a repo with only one maintainer, when authoring a PR in that repo, can choose reviewers entirely at their discretion.

In order for a PR to be merged, everyone who has been tagged as a reviewer must have reviewed it. (The reviews do not all need to be approvals: in particular, a PR can be merged over the objections of a reviewer if the maintainer disagrees with that reviewer's requested changes. The maintainer(s) review(s), however, must be approvals). As a consequence of this, reviewers who don't have the time to review a PR reasonably promptly, or believe another reviewer would be more appropriate, are strongly encouraged to untag themselves and/or tag others, rather than leave the PR unreviewed. The PR author can also untag an unresponsive reviewer and potentially tag another. The resulting set of reviewers must still contain at least one maintainer.

## PR scope and structure

The scope and structure for a PR should be based on the guiding principles that apply to [commit and history structure](commits.md): PRs should ideally cover a self-contained set of changes, with an overall scope that is large enough that the overall intent of the changes is clear, and small enough that it is manageable to be reviewed in detail. PRs that are too large tend to result in reviews that are more superficial and less effective.

The use of branches generally should follow the policy for [development flow](development-flow.md). If the changes being made are necessarily extensive, then the preferred way to structure the work is as a series of PRs made against an integration branch, so each individual PR remains a manageable size.

Individual changes that impact a very large number of files (for example bulk application of a code style change, or renaming a widely used identifier) should be made as separate commits (or ideally separate PRs).

## Linking to issues

PRs should be linked to the issues they are fixing:

- You can link Jira issues to the PR by including the issue key in the title of the PR [WEB-123] or by simply including it in the PR description WEB-123. Github issues can be linked by following [this guidance](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)

## PR status and labelling

PRs at any time can have one of a number of statuses:

- `in progress`: the PR is not ready for review. The author of a PR might wish to raise a PR containing work that is still in progress in order to get early feedback, or to provide a venue for discussion of the set of changes within the PR's scope.
- `ready`: the PR is ready for review. The author the PR is advertising the work as completed to their satisfaction, and proposes it for review and merging.
- `approved`: the PR has undergone review, and satisfies the approval requirements of the repo (such as having approval of sufficiently many maintainers).

Additional statuses might exist in certain repos, where there is a specific requirement to manage PRs post-approval (for example where the sequence of merging is important).

PRs are indicated as being `in progress` either by being a [Draft Github PR](https://github.blog/2019-02-14-introducing-draft-pull-requests/) or by having an `in-progress` label. (It is not possible to make a PR Draft in Github if it has previously been ready for review.)

PRs are not labelled as having `approved` status, but the approval status of each individual review is indicated by Github. A PR has `approved` status if its review statuses, collectively, meet the requirements of the repo.

Transition to `ready` is usually under the control of the author, but that transition can be made by a maintainer at the maintainer's discretion. Transition back to `in progress` is usually also made by the author, resulting from their decision as to how to respond to review feedback. (It is possible of course that the decision could instead be to close the PR.)

Transition to `approved` is under the control of the maintainer reviewers.

PRs that are raised in `in progress` state should, as far as possible, contain commits that the author intends to become part of the final history. Review feedback can validly include feedback about the commit structure of a PR as well as about the content.

PRs should include other labels when raised, according to the [Tags policy](https://ably.atlassian.net/wiki/Tags). At least, this should include a label indicating the purpose of the change (ie `enhancement` versus `bug`), and the importance (ie `important` vs `critical`).

## Conducting PR reviews

PR reviews have the principal aim of ensuring that a PR meets its stated goals and improves the overall health of the codebase it applies to. We recommend that reviews follow the [Google engineering best practice for code reviews](https://google.github.io/eng-practices/review/reviewer/standard.html). Read these guidelines fully.

PR reviews should be conducted using Github's Review feature. Use the available Github functionality, such as resolving individual comments, as much as possible to ensure that the status of the review and responses are clear.

Reviews should be conducted in a timely way so as not to impede the authors' work. When an author is made to wait for a review, not only are they stalled, as they may be unable to work effectively on something else in the meantime, but the delay and context-switch adversely impact their ability to resume once the review is complete. Reviewers should aim to do a PR review shortly after it comes in, except when in the middle of a focused task. One business day is ordinarily the maximum time it should take to respond to a PR review request (ie first thing the next morning).

PR review comments should be courteous, objective, clear and non-confrontational. It is legitimate for the reviewer to have strong technnical objections but these must be stated and explained clearly. Comments must always apply to the contribution and not the contributor. Reviewers must also remember that PR reviews are an important vehicle for mentoring, so should balance comment on the contribution with explanation and suggestion.

Acceptance or otherwise of the content of a PR should be made on the basis of the following principles:

- Technical facts and data overrule opinions and personal preferences.
- On matters of style, the style guide is the absolute authority. Any purely style point (whitespace, etc) that is not in the style guide is a matter of personal preference. The style should be consistent with what is there. If there is no previous style, accept the author’s. Every repo should contain an explicit style guide linked from its `README` and implemented in an `.editorconfig` and linter/style checker build targets.
- Aspects of software design are almost never a pure style issue or just a personal preference. They are based on underlying principles and should be weighed on those principles, not simply by personal opinion. Sometimes there are a few valid options. If the author can demonstrate (either through data or based on solid engineering principles) that several approaches are equally valid, then the reviewer should accept the preference of the author. Otherwise the choice is dictated by standard principles of software design.
- If no other rule applies, then the reviewer may ask the author to be consistent with what is in the current codebase, as long as that doesn’t worsen the overall code health of the system.

## Implementing PR feedback

Changes that are made in response to PR reviews can include:

- making further commits, for example to add functionality or tests;
- amending existing commits (ie appending commits that amend earlier commits using the [Git fixup mechanism](https://git-scm.com/docs/git-commit));
- closing the PR and submitting a separate PR.

The choice as to how to proceed principally rests with the author, and the actual choice should be made based on the goals of:

- ensuring clarity for the reviewer(s);
- ensuring that the final history meets the [goals for commit history](commits.md).

Adding `!fixup` references allows the specific corrective changes to be seen clearly, and preserves the navigability of the original PR comments. However, depending on the nature and extent of the changes, `!fixup` commits can impair the reviewability of the PR overall - a reviewer may request that changes are consolidated into the actual proposed commits in this case. When this happens, a new branch and PR should be used referencing the old PR, explaining why a new PR is being used (what material change has been made) and the old PR should be closed.

Feedback and associated changes must be conducted to the satisfaction of the reviewer, or another maintainer in the case of a dispute.

## Merging PRs

By default the author is expected to merge a PR once it is approved. Whether this is by merge or rebase is subject to considerations relating to the overall [flow and branching policy](development-flow.md).

For certain repos - especially where there is a very broad scope, and contributions by multiple teams - it might be necessary that a maintainer, rather than the author, determines the order in which PRs are landed. It is the responsibility of the maintainers of those repos to define the policy for merging in such cases.

After a PR is merged, the branch should be deleted.

## Etiquette

### Reviewer Count

Enforced number of approvals is based on that PR contains trivial changes. On any instance of a non-trivial change approval of more than one reviewer should be sought.
While 'trivial changes' is a subjective matter, developers should use their own judgements. Some examples of trivial changes are:

- Comment changes
- Non public function / class / variable renames
- Code formattings
- A string literal, an error code where the change is well documented - such as in a feature spec document

Any other changes to the code will benefit from reviews from more than one person. Some example changes that are not trivial are:

- Bug fixes
- Change, Addition or deletion of functions, classes, variables, etc
- Refactorings

In some instances the number of reviewers should be increased to more than two people. Some examples of such changes are:

- Public API change
- Library structure changes - such as new modules, extensions, splits, etc.
- A change on a core algorithm - for example the way the library handles message queueing
- An important architectural change - such as internal communication architecture, message flow architecture, etc.

### Rule Bending

Our protection rules for the default branch (`main`) across our repositories enforce various requirements on pushes to that branch (a.k.a. pull requests being merged to there). These include:

- threshold count of reviewer approvals matched
- all conversations resolved
- all CI checks successful
- contents is up-to-date with the target branch

However, those in our GitHub org who have `Admin` permissions over any given repository can use that privilege to merge pull requests even if not all the rules defined have been satisfied. While it is recognised that there are, sometimes, pragmatic reasons for doing this - it should be avoided. If, however, as a last resort this override is used then the person landing the contravening pull request **must** write a comment on the pull request explaining their reasons.

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
  - Modify commits already in the pull request to address changes needed (squash, force push)

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
