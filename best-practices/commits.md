# Ably Engineering Team: Guidance on Git commits

This document is intended as a canonical reference documenting how we prefer to have commits in the public domain / open source:

## Overview

We use Git, via Github, as the way we work with code. This means that git provides the repository for our code - so everyone can access it and know the current state - and it is also the medium (via Pull Requests) by which we review, discuss, and approve changes.

However, there is an overriding philosophy of how source control is applied that is more important than any of these details; it is the idea that the history is the deliverable, not the code. To deliver code that we can use, understand, maintain and extend, there needs to be an effective commit history. Maintaining quality in the history is as important as maintaining quality in the code itself.

These notes are intended to provide the guidelines by which we achieve that. However, understand that the goal is more important than the individual guidelines, and we are open to evolving these rules to ensure they are as effective as possible.

## Applicability

These principles are goals for the commit history for shared branches in our repositories. Shared branches are those that are worked on by multiple developers, or have history that is problematic to rewrite for other reasons. The commit history in shared branches should satisfy these goals, either because the branch is enduring in its own right (eg `main`, or the default branch in any repository), or because the history in the shared branch will eventually end up in an enduring branch. Feature and integration branches, or any branch associated with a PR for which review is requested, should be considered to be a shared branch.

Branches that are private, or disposable - that is, solely for use temporarily by an individual developer - can be managed in a less strict way; there can be advantages to doing that in some situations, such as when early feedback is sought on an avenue of development, and the code and/or history are not being advertised as final.

When working in your local repository, it is also possible to treat history as rewritable, provided that the history is cleaned before pushing to the shared repository. Tools such as [interactive rebase](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History), [interactive staging](https://git-scm.com/book/en/v2/Git-Tools-Interactive-Staging) can be used to ensure that a well-structured history is constructed before sharing code, even if the local history initially reflects the experimental nature of the development.

## Basic principles

### Commits should be coherent, atomic changes

A commit should take the codebase from one coherent state to another coherent state.

Heuristic: in a pull request consisting of N commits, for any n ≤ N, you should be able to merge only the first n commits and still get a codebase that passes CI. That is, later commits can depend on changes in earlier ones, but a commit shouldn't break things and rely on a later commit to fix them.

This isn’t just aesthetics and cleanness (though that is a part of it). There are practical reasons for it too: for example, git bisect is more useful the more points in the git history are coherent.

### Commit Related Changes

A commit should be a container for changes that are related to one another and have a defined purpose. For example, fixing two different bugs should produce two separate commits. Small commits make it easier for other developers to understand the changes and roll them back if something went wrong.

With tools like the index and the ability to stage only parts of a file, Git makes it easy to create very granular commits.

### Commit the right amount of change

Together, the two constraints above define the right size of a commit: relatedness encourages you to split off bits you can, atomicity prevents you from splitting off bits you can’t. ‘As small is it can be, and no smaller’.

Note that sometimes ‘as small as it can be’ can be very large indeed, and that can be ok. If you’re changing some subsystem that requires touching thousands of files, and no ‘half-done’ state would be coherent, then the commit may be enormous. But that’s fine - the goal isn’t physical smallness as measured by line count or something, nor is it ‘normal sized’ commits, it’s conceptual atomicity. Extreme example: a PR with two commits, one of which changes thousands of lines in a major refactoring, the other of which fixes a one character typo in a log message. This is fine: if each is a coherent change, so that may well be the right way to split them.

### Feel free to reshape commits as you go along, before you make a PR, and before you merge. (But not after!)

While it’s a nice idea to only commit code when a meaningful and coherent set of changes is complete, if it doesn’t end up working out what way, that’s fine. Feel free to commit as you go along, either to save a work in progress on a branch when you need to work on a different branch, or to re-pull `main`, or just to make a ‘save point’. This is fine. (Some advocate using git stash for this, but stashes are not inherently associated with the branche you were on, so much harder to keep track of if working on many branches in parallel, and difficult to recover from the reflog if you lose track of them). No-one will ever see your 72 “wip” commits; when it comes time to make a pull request, just `git reset` back to before your wips, and use `git add -p` to mold some beautiful, coherent commits from raw clay, ready for your reviewers to admire.

There’s also interactive rebase, which comes into its own when your commits are already approximately what you want, but just need combining, reordering, and/or commit-message editing.

### Use fixups to address PR review feedback

If a PR reviewer requests that you make a change to an existing commit, you can use a fixup commit (`git commit --fixup <sha>`) to make a commit that shows its intent to modify the other commit, which can then be reviewed to make sure it’s the right fix. Then before you merge the PR, you can do an interactive rebase, which will merge the fixup commit into its target.

Note: you need to do this yourself - github will not do this for you automatically when merging!

### Write Good Commit Messages

Begin your message with a short summary of your changes (up to 50 characters is a guideline, but balance that with the need to be genuinely informative). Most of our repositories contain multiple components, so messages should always include an explicit indication of the component the change relates to.

Commit messages that require additional detail should include that by having the detail separated from the summary line by including a blank line. Significant changes should include this so that the motivation and principal technical details or choices are clear from the history. When deciding what goes into a commit message versus what goes into a PR decription, think about what you would want to know as a developer if you only have access to the history; the PR needs to include any discussion, but the history needs to capture the resulting material impact on the code.

The body of a detailed message should provide answers to the following questions:

* What was the motivation for the change?
* how does it differ from the previous implementation?

Use the imperative, present tense («change», not «changed» or «changes») to be consistent with generated messages from commands like git merge.

### Examples of good practice

#### Example 1 (no description, only summary)

```shell
   commit 3114a97ba188895daff4a3d337b2c73855d4632d
  Author: [removed]
  Date:   Mon Jun 11 17:16:10 2012 +0100

    Policy manager: update default policies for KVM guest PIT & RTC timers
```

#### Example 2 (description as bullet points)

```shell
   commit ae878fc8b9761d099a4145617e4a48cbeb390623
  Author: [removed]
  Date:   Fri Jun 1 01:44:02 2012 +0000

    libvirt: refactor create calls

     - Minimize duplicated code for create

     - Make wait_for_destroy happen on shutdown instead of undefine

     - Allow for destruction of an instance while leaving the domain
```

#### Example 3 (description as plain text)

```shell
   commit 31336b35b4604f70150d0073d77dbf63b9bf7598
  Author: [removed]
  Date:   Wed Jun 6 22:45:25 2012 -0400

    Scheduler: add CPU arch filter support

    In a mixed environment of running different CPU architectures,
    one would not want to run an ARM instance on a X86_64 host and
    vice versa.

    This scheduler filter option will prevent instances running
    on a host that it is not intended for.

    The libvirt driver queries the guest capabilities of the
    host and stores the guest arches in the permitted_instances_types
    list in the cpu_info dict of the host.

    The Xen equivalent will be done later in another commit.

    The arch filter will compare the instance arch against
    the permitted_instances_types of a host
    and filter out invalid hosts.

    Also adds ARM as a valid arch to the filter.

    The ArchFilter is not turned on by default.
```

### References in commit messages

If the commit refers to an issue, add this information to the commit message header or body so that GitHub can turn these into links to issues. For issues in Jira it is possible to use autolink references for the same effect.

In header:

```shell
[#123] Refer to GitHub issue…
```

```shell
CAT-123 Refer to Jira ticket with project identifier CAT…
```

In body:

```shell
 …
Fixes #123, #124
```

### More information

There is also good information in:

* https://chris.beams.io/posts/git-commit/
* https://wiki.openstack.org/wiki/GitCommitMessages#Information_in_commit_messages
