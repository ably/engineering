# Ably SDK Team: Glossary

Here we define terminology used by the SDK Team at Ably.

Some terms defined here are quite specified to the Ably context, or even the SDK development context.
Other terms are more generally understood in engineering circles, however we still see benefit in expanding on them here as there are often interpretations or pointers which this document can convey in order to add value for the reader.

Our aim is to make this glossary as accessible as possible, which means making every effort to write definitions in such a way that they can be understood by individuals with varying levels of technical knowledge or capability.

## Features Specification

Our canonical source of truth for client library SDK implementations.

See:
[Future Direction for the Client Library Features Specification](https://github.com/ably/ably-common/tree/main/features#future-direction-for-the-client-library-features-specification)

## Spec

See [Features Specification](#features-specification).

## Tag

Generally referring to a [Git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging).
These are mostly used when we make SDK releases, where we create a new tag for that release, referred to as a [Version Tag](releases.md#version-tag).

## Websocket

The networking protocol that underpins the realtime connectivity to the Ably service within our SDKs.

## Wrapper

A term we commonly use where one SDK wraps another SDK as an implementation detail.
Examples include our
[Flutter plugin](https://github.com/ably/ably-flutter)
and our Asset Tracking SDKs for
[Android](https://github.com/ably/ably-asset-tracking-android)
and
[iOS](https://github.com/ably/ably-asset-tracking-swift).
