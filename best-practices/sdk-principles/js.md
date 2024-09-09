# Client software (SDK) principles and best practice (RFC)

## Background

Historically Ably has had just one product, which is a pub/sub offering with additional high level features designed to make it easier for developers to deliver realtime features
in their applications and services. [Presence](https://ably.com/docs/presence-occupancy/presence) is a good example of a layer on top of pub/sub with an API exposing presence as a feature, and our integrations are good examples of
features we built to make it easier to integrate Ably into your application stack.

With the recent introduction of product SDKs in 2023 (for [Spaces](https://github.com/ably/spaces), [Models](https://github.com/ably-labs/models)) and the release of [Ably Asset Tracking](https://ably.com/docs/asset-tracking) in 2022, it has become evident that we need to balance both agility
and autonomy of teams working on new client software (SDKs), whilst also ensuring where possible/practicable, we have consistency in, amongst other things, the API, our testing strategy,
versioning approach, developer tools, observability, debugging and integration with the core SDKs.

## Product strategy context

Before we dive into the client software best practices, it’s important we are all aligned on our product strategy.
In our 22nd NTK of 2023, we present an [SLT Strategy update](https://ably.atlassian.net/wiki/spaces/PEO/pages/2461434058/2023+Need+to+knows#%2322-2023-Need-to-know-(29th-of-June-2023)---SLT-Strategy-Update),
which included a section on how our product strategy is evolving. If you are unclear on the product strategy, please listen to the recording for slides 12 → 31
(11m 50s → 37m-ish).  The TLDR version as of June 2023 is summarised in slide 30 below:

![Product Strategy](/images/product-strategy.png)

1. **Ably’s Core product is Pub/Sub Channels**. This is the product that we launched back in 2016, and has continued to be the driver for developers to deliver any type of realtime functionality they require in their applications. The core product and the associated SDKs are considered to be a set of lower level API primitives that can power anything from Chat, to Multiplayer, to Broadcast, but typically a developer needs to handle the application space logic (like how their Chat works), whilst we handle the the lower level functionality reliably and at scale, such as pub/sub messaging, history, presence, authentication, etc.

2. Ably’s **newer products** aim to solve a **use case or more specific technical problem**. Take for example Spaces (our multiplayer offering). Whilst it is is built on to of Pub/Sub channels, it exposes a set of APIs to solve specific requirements for developers who want to add multiplayer collaboration to their apps. As such, we offer a Locks API, a Locations API, and a Cursor Tracking API. The complexity of these new SDKs is not necessarily high, but that’s less important quite frankly.  What is important is that a developer can, for example, be abstracted away from how live cursors works and can use an API that is specifically designed to help them solve that specific problem. Our goal with our higher level API product offerings is to take away more of the complexity from developers, and offer purpose built APIs that make it easy for developers to work on their application logic, as opposed to common use case logic relating to realtime experiences, such as delivering chat, or keeping the application state in sync with the server, or showing what other participants are doing inside a collaborative application.  

Please see slide 29 from the SLT strategy update for considerations we need to bear in mind:

![Product Consideration](/images/product-consideration.png)

1. On whether each product needs an SDK or not:

   a. Multiplayer & Spaces, as of Aug 2023, are providing new SDKs

   b. Ably Asset Tracking already has its own set of SDKs

   c. Conversations (Chat) functionality and Notifications are currently planned to be part of the core pub/sub channel SDKs, but that is subject to change as this evolves.

## Proposal for SDK hierarchy, composability and consistency

When it became evident that we needed more clarity on our product strategy (how our new products fit together, naming, hierarchy, product boundaries) and how our SDKs fit into that strategy,
Matt O wrote a document for comment [2023 - Product terminology and taxonomy (2023 - Apr-May)](https://docs.google.com/document/d/1IpCJL7ME0JavWOjPL0VbsAVOy7nlO-A05H4Lf3vAbqA/edit).
In this document, various options are presented in terms of how our SDKs should evolve in terms of the core SDKs, their composability, and our new product SDKs.
The [v2 proposal](https://docs.google.com/document/d/1IpCJL7ME0JavWOjPL0VbsAVOy7nlO-A05H4Lf3vAbqA/edit#heading=h.jx5io6mmxzz), which is the current recommendation, is presented below.

This proposal ensures that we:

- create broader-scoped product SDKs that expose proposed functionality as collections or attributes so as not to limit the scope of the root object i.e. spaces has space.locks, space.members, space.cursors thus ensuring it’s extensible and we could add space.foo.

- standardise how we create and release objects;

- we consistently refer to the core SDKs as clients

## Core and product simplified code examples

### Core SDK (exposes Channels & Notifications)

Our current pub/sub SDKs should be referred to as our core SDKs. It is perfectly valid for a developer to only user a core SDK given it provides a rich feature set of pub/sub+ capabilities.

```typescript
import Ably from '@ably/core';
const client = new Ably.Realtime(clientOptions);
```

### Composable Core SDK

For languages that support composability (currently only the core), we should should have just one way of adding support for features to a base client (stripped back) core, or the standard core.
Currently we have [plugins for features like Deltas](https://ably.com/docs/channels/options/deltas?lang=javascript), and have a different approach for our current [composable and tree-shakeable Javascript SDK](https://github.com/ably/ably-js/issues/1210).
We should standardise on this and take one approach.

Example with a lightweight base client adding subscription, presence and delta support:

```typescript
import RealtimeBase from '@ably/core/realtimebase';
import RealtimeSubscriptionMod from '@ably/core/mod/realtimesubscription';
import RealtimePresenceMod from '@ably/core/mod/web/realtimepresence';
import VCDiffMod from '@ably/vcdiff-decoder';
const client = new RealtimeBase({
  key: 'xVLyHw.0RRPmg:JBNRyepNu6YBGGi2eiPuIwzn-D2wxLnXD2CicinBeHw',
  modules: [VCDiffMod, RealtimeSubscriptionMod, RealtimePresenceMod]
});
```

Example with the Core client adding delta support:

```typescript
import RealtimeBase from '@ably/core';
import VCDiffMod from '@ably/vcdiff-decoder';
const client = new RealtimeBase({
  key: 'xVLyHw.0RRPmg:JBNRyepNu6YBGGi2eiPuIwzn-D2wxLnXD2CicinBeHw',
  modules: [VCDiffMod]
});
```

### Data Sync (current proposed product name is Live Sync)

```typescript
import { Realtime } from '@ably/core';
import DataSyncClient from '@ably/datasync';

const rtclient = new Realtime(ABLY_API_KEY);
/* Note that a Data Sync client uses an underlying core client */
const dsClient = new DataSyncClient(rtclient);
/* Note that models is exposed as a collection on the root ensuring extensability */
const model = dsClient.models.get<PostEvent>({
    name: 'post'
});

model.on('post', 'update', (state: Post, event: PostEvent) => event);

// Note that the model simply exposes the channel state events directly. 
model.on('attached', () => { ... });

// An alternative TBD could be to expose the underlying channel so that developers understand how the model is underpinned by a channel and can read the channel docs for state management
model.channel.on('attached', () => { ... });

// Expose realtime connection events directly 
dsClient.once('connected', () => { ... });

// An alternative to above, TBD
dsClient.connection.once('connected', () => { ... });

// Never hide the underlying connection, channel etc. 
// It's a strength to expose these objects that allow devs to tap into lower level flexible APIs
model.channel // -> RealtimeChannel from Core
dsClient.connection // -> RealtimeConnection from Core
dsClient.client // -> Realtime from Core
```

### Spaces

This is an evolving API, but hopefully the principles are highlighted below, namely wrapping the core, exposing the underlying core objects such as channels, connections, and utilisation of the standard eventemitter pattern for updates.

```typescript
import { Realtime } from '@ably/core';
import Spaces from '@ably/spaces';

const client = new Realtime(ABLY_API_KEY);
const spaces = new Spaces(client);

/* Standardised use of `get` to retrieve an object, like we do for channels
const space = spaces.get('demoSlideshow'); */
space.subscribe('update', (state) => { /* space update */ ... });
space.members.subscribe('leave', (member) => { ... })
/* Shorthand for space.members.enter */
space.enter({ 
  username: "Claire Lemons",
  avatar: "https://slides-internal.com/users/clemons.png",
});

space.channel // -> RealtimeChannel from Core
space.channel.on('attached', () => { ... });
spaces.connection // -> RealtimeConnection from Core
spaces.connection.once('connected', () => { ... });
spaces.client // -> Realtime from Core 
```

### Asset Tracking

The AAT APIs are unlikely to be changed unless we decide to further develop the Asset Tracking product, however should it be developer further, we’d like to make it consistent with other SDKs as follows:

```typescript
import { Realtime } from '@ably/core';
import { SubscriberClient } from '@ably/asset-tracking';

const client = new Realtime(ABLY_API_KEY);
const subClient = new SubscriberClient(client);
// Get an asset.
const asset = subClient.assets.get('my_tracking_id');

asset.channel // -> RealtimeChannel from Core
subClient.connection // -> RealtimeConnection from Core
subClient.client // -> Realtime from Core 
```

### Notifications

In the future, as we develop a more complete notification offering (not just push notifications, but consider a notification center where we provide APIs to handle delivering in-app notifications, @ mentions, manage read status, smart notification of devices only when a user has not seen it on their desktop etc), we may consider removing notifications from the current core SDKs into their own client, example:

```typescript
import { Realtime } from '@ably/core';
import { PushNotificationsClient } from '@ably/notifications';
import { PushAdminClient } from '@ably/notifications';

const client = new Realtime(ABLY_API_KEY);
const pushClient = new PushNotificationsClient(client);
pushClient.activate();
const pushChannel = pushClient.channels.get('foo');

pushchannel.channel // -> RealtimeChannel from Core
pushClient.connection // -> RealtimeConnection from Core
pushClient.client // -> Realtime from Core 
```

## Best practice guidelines for SDKs

In no particular order, below is a list of best practices and guidelines for each SDK. Whilst the right architecture, naming and structure for each SDK will be decided by each team working on this software, we need to be intentional and have a solid basis when we deviating from broader best practice, conventions and learnings we have from building SDKs over the last 7 years.

> [!WARNING]
> It’s an anti-pattern to think that any of the following points can be deferred until the first Release Candidate or General Availability release. Ignoring these best practices from the get go will likely lead to bugs, quality issues experience by customers, and delays when trying to move a release into RC/GA state. A move to RC/GA should not typically require a refactor / considerable work, it reaches that state because the software has proven to be stable enough to mature one of these states

1. **Observability**

    We’re striving to be a data-driven organisation. As we build new products and features, insights into how these capabilities are being adopted will help inform future roadmaps, further investment and prioritisation. With every new SDK and feature, we need to consider how we’ll measure usage. Given the product SDKs we plan today use the Core SDK to establish a connection and manage channels, and customers can simultaneously use the Core SDK functionality as well as one or more product SDKs, some thought needs to be given to how feature usage can be tracked as opposed to just attributing usage to an SDK via. user agent. See related [Channel types / user-specified metadata proposal](https://github.com/ably/ideas/issues/458) which includes a proposal to track usage by channel type.

2. **Event naming and listener subscription consistency**

    Where possible, the names of events and object states should mirror existing naming used in our Core SDKs. For example, the Spaces SDK supports users being present in a space. The events emitted relating to users being present in a space should use `enter`, `leave`, and `update` as the event names unless there is a compelling reason to deviate from the events emitted and documented by the core.
    <br /><br />
    Note that:

    - Generic state changes are subscribed with the `on` method, such as connection or channel state changes.

    - User submitted or domain-relevant events with the `subscribe` method, such as messages published on a channel, or cursor positions emitted. Note that in our Core SDK, we have an [inconsistency with the Presence API](https://github.com/ably/specification/issues/164) that should perhaps be fixed down the line.

    - Whilst TypeScript supports different event types based on the event name (for example, an `enter` event could emit a different type to a `disconnected` event), most languages do not. Given Ably is a cross-platform solution, we should aim to avoid having an event handler emit different types. For example, for channel state changes an `on` event handler may emit a `ChannelStateChange` event, however if we want to emit an error, instead of supporting for example `on(Error) -> ErrorEvent`, we prefer to have a separate method such as `onError -> ErrorEvent`. This latter approach ensures that as we aim to support more languages & platforms, we can have a more consistent API and consistent documentation.

3. **Connection and channel state changes should not be hidden from users**

    We should encourage developers to handle advanced state changes through the underlying connection and channel objects given these state changes are hardened, well documented, and cannot be simplified into, for example `online` or `offline` states. For example, when a channel becomes `failed`, it’s a terminal state that needs to be handled differently (probably an authentication / capability issue), as opposed to `disconnected` state which is a temporary state. In addition, when a connection is `disconnected`, given it’s a temporary state, users can continue to publish event that are queued, vs `suspended` where the state indicates there will be discontinuity once it becomes `connected` again. Trying to oversimplify this for developers is likely to lead to issues in real-world scenarios where developers will find out how these states affect the user in practice. However, if there is a simplified set of state events that make sense exposing, such as `online` vs `offline`, and there is a high level of confidence this won’t a) mask lower level events that a developer really does need to know about, b) result in a lack of documentation making developers aware of the underlying events, then this can be considered on a case by case basis.

    - Note that in Dec 2022, when we had catastrophic failures in the Ably Asset Tracking product when it went into production, much of the problems surfaced related to attempts to hide the underlying states and wrap them in an oversimplified event interface for developers.

4. **Consistent error and state condition handling**

    Product SDKs must be aware of the underlying states of the channel and connection and bubble up appropriate state changes and errors. Product SDKs must be designed for the unhappy path, where connections and channels fail temporarily or permanently, and emit suitable events so that developers have an intuitive API that helps them build robust and reliable software. A few additional considerations:

    - We have generic [ErrorInfo](https://ably.com/docs/api/realtime-sdk/types?lang=javascript#error-info) type that we emit in the Core SDKs. We should consistently emit this same error type in all other SDKs as it provides a lot of conveniences such as [unique error codes](https://github.com/ably/ably-common/blob/main/protocol/errors.json), [automatic tracking of new error codes being investigated by devs and automatic linking to FAQs](https://github.com/ably/ably-common/tree/main/protocol#error-codes).  

        - Do not wait until the end to use ErrorInfo objects and assign unique error codes! Follow best practice from the get-go and start emitting helpful errors with unique error codes. Developer Experience will be significantly improved as a result.

    - It is almost never suitable to have hard coded timeouts in product SDKs that relate to expected underlying events happening in a particular time frame. For example, if you publish an event or attach to a channel and don’t receive an ACK in the expected time frame, putting a timeout around the activity is ill advised as it could succeed after the timeout fails. You should design your code to wait for the appropriate state change or event failure from the underlying core SDKs. Core SDKs expose APIs and listeners for every event to succeed or fail.  

        - Note that in Dec 2022, when we had catastrophic failures in the Ably Asset Tracking product when it went into production due to issues relating to timeouts being added to the AAT code base that meant underlying events could fail or succeed afterwards.

5. **Memory management and explicit disposal**
  
    Product SDKs must provide functionality to manage how objects are dereferenced and/or explicitly released to ensure long lived applications don’t accumulate memory assigned to unused objects or worse continue to cumulatively subscribe to increasingly more events that aren’t actually being consumed or needed by the application. For example, if the Spaces SDK implicitly attaches to a channel when creating a new space, then it must expose methods to explicitly detach from the channel, and free the object if no longer in use. Offering functionality to separately unsubscribe from events (and possibly detach) as well as release the object completely (which should lead to disposal and an appropriate finalisation process) is preferable so that developers can choose to put an object into a dormant state (and potentially keep all listeners registered for example) vs release it completely (which release all references and listeners).

6. **Packaging in directories**

    We should not release alpha/labs packages into package directories with locations other than what it is intended for when it is finally released. See [npm: @ably-labs/react-hooks](https://www.npmjs.com/package/@ably-labs/react-hooks) for example. For us to now release this to the wider community, we have to deprecate that library and create a new one at `@ably/react-hooks`. NPM provides no way to move all users from the old library to the new one, which creates friction. Instead, we should use release tags to indicate a project is in alpha/early access/experimental such as `v0.0.1-alpha`, and we should continue to use tags to signpost the maturity of the module such as `v0.9.0-betaor` `v1.0.0` for the first GA release.

7. **Testing pyramid**

    Test coverage of SDKs should include a good range of unit, integration and complete end to end tests.  Running tests that don’t actually use an underlying connection to the Ably service will lead to unreliable software in production, as we’ve seen over and over again, and more recently catastrophically with AAT. Stubs/mocks are great for unit tests, and possibly even integration tests, but complete end to end tests that communicate with the actual realtime (sandbox) service are not optional. It is near on impossible to predict how network latency and non-deterministic timing from a distributed system impacts the client software we are developing. Using a real network helps mitigate that. The contract we provide to our customers is that they can trust the APIs they consume. It is up to us to ensure we honour the contract end to end.

8. **Versioning and feature tracking**

    Whilst in the early stages of development we need to move quickly with SDK development, and will often prefer writing code as opposed to writing specs, that does negate the need for us to track the features and APIs we provide in our SDKs. For our Core SDKs, we have an Interface Definition (see “Interface Definition” of [core spec](https://sdk.ably.com/builds/ably/specification/main/features/) as an example) that describes a language independent API, a specification document that describes the intended behaviour of functionality we provide, as well as a [feature tracker](https://github.com/ably/ably-ruby/blob/main/.ably/capabilities.yaml) for each SDK that ensures we know which features and specs are implemented in each SDK. Each new SDK should be accompanied with a lightweight IDL, spec, and feature tracker, that can be matured when/if we decide to support multiple platforms or languages.

    - Note that we support [Semver versioning and each SDK should maintain it’s own version number](https://github.com/ably/specification/#specification-version) (we no longer aim to have consistent versioning between each SDK, and instead have a [consistent protocol and spec version](https://github.com/ably/specification/#protocol-version) which may or may not apply to new product SDKs).
