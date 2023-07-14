# Ably Engineering Team: Guidance on Releases

The process defined below is the adopted approach to managing the development for the principal internal repos in the Ably organisation; ie `realtime`, `infrastructure`, and `website`. For other repos, this approach is also recommended, although there might be specific requirements or constraints in other repos that make a different approach more suitable.

The approach described here is pretty close to that described for [One Flow](http://endoflineblog.com/oneflow-a-git-branching-model-and-workflow).

There is a single primary long-lived branch, `main`.

We aim to keep history reasonably linear, as much as is practical. That is: you should rebase your working branch against the current `main` prior to raising a pull request. (And if the PR process takes sufficiently long that `main` has advanced a good deal by the time you come to merge it, you should rebase again — and let CI run again! — prior to merging it). This has several advantages. For example:

- The rebasing forces you to present your proposed change as a change against the immediately-previous `main` `HEAD`, rather than against an ancestor that no longer represents the current state of the code (with the mismatch then only exposed and dealt with when resolving conflicts in a merge commit, left separate from the main commits and excluded from the GitHub code review process)
- As a result of the previous point, it makes it possible to able to walk back step-by-step through the history of some function / line, and see the commit message for each change, to see how the function evolved and what the reasoning was at each step
- It means that the CI build run by the PR is running against a state of a codebase that approximates as closely as possible the state of the codebase post-merge, reducing the chance of bugs from concurrent changes slipping through ci. (Not all such bugs involve actual line conflicts that git can flag up for resolution).
- It makes the git log graph much more readable, making it possible see properties like which other changes are included in a given release and what aren't at a glance, rather than needing to use programmatic queries like `git merge-base --is-ancestor`
- It makes git bisect work much better

PRs may be merged with --ff-only (github: 'rebase and merge', github automatically rebases for you) or --no-ff (github: 'create merge commit', after manually rebasing) according to your judgement. Generally, if a bunch of commits are related and it would help legibility for that to be obvious from the git history, you should use a merge commit (after rebasing). If not (eg PRs that are just one commit, or which are a roundup of not-really-related fixes), fast-forward merges ('rebase and merge') are fine.
