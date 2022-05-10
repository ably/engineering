# Ably SDK Team: Features Specification

## Overview

Source location:
[**`ably/docs`** `/content/client-lib-development-guide/features.textile`](https://github.com/ably/docs/blob/main/content/client-lib-development-guide/features.textile)

Published locations:

- Primary (main website): [ably.com/documentation](https://ably.com/documentation/client-lib-development-guide/features/)
- Preview: [docs.ably.com](https://docs.ably.com/client-lib-development-guide/features/)

## Contributing

To contribute to the Features Spec, clone the docs git repository from GitHub and:

1. Follow the “Quickstart” section from the docs repository README to run the docs site locally. Note that in addition to these instructions, you may also need to install a version manager for Ruby such as `asdf` to set the correct version of Ruby required by the docs site.
2. Edit the Features Spec source file at `content/client-lib-development-guide/features.textile` and preview your changes locally.
3. Once satisfied, open a pull request (see [Contributing to the Docs](https://github.com/ably/docs#contributing-to-the-docs))
4. As part of landing a pull request that requires SDK changes, open issues in all client library repositories to indicate what’s changed in the specification and needs implementing in that client library. These issues need to be as verbose as possible and should refer back to related docs PRs.

## Guidelines

When making changes to the spec, please follow these guidelines:

- **Ordering**: Spec items should generally appear in ID order, but priority should be placed on ordering them in a way that makes coherent sense, even if that results in them being numbered out-of-order. For example, if `XXX1`, `XXX2` and `XXX3` exist but it would make more sense for `XXX3` to follow `XXX1`, then just move the spec items accordingly without changing their IDs
- **Addition**: When adding a new spec item, choose an ID that is greater than all others that exist in the given section, even if there is a gap in the currently assigned IDs. This is desirable so that client library references to spec items are still semantically valid even after they are removed from the spec rather than now having different semantics due to the ID being re-used. For example, if `XXX1a` and `XXX1c` exist but `XXX1b` doesn’t because it was removed in the past, then introduce `XXX1d` for the new spec item rather than re-using `XXX1b`
- **Removal**: When removing a spec item, it must remain but replace all text with “This clause has been deleted.”. See [#1057](https://github.com/ably/docs/pull/1057) for an example of this in practice.
- **Deprecation**: Our approach to deprecating features is yet to be fully evolved and documented, however we have a current standard in place whereby the text "(deprecated)" is inserted at the beginning of a specification point to declare that it will be removed in a future release. The likely outcome is that in the next major release of the spec/protocol we'll remove that spec item, per guidance above.
