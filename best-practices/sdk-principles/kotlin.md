# Client software (SDK) principles and best practice for Kotlin (and any other JVM language)

Background and product stratagy context can be found in [SDK principles for JS](js.md)

Kotlin is the primary development language for any JVM-based SDKs (Java, Scala, Groovy, Clojure, etc). Our main focus is to provide an idiomatic Kotlin API for our customers. However, upon request, we will also offer a Java package that does not use coroutines or extension functions, making it easier to consume from Java (similar to [apollo java support](https://github.com/apollographql/apollo-kotlin-java-support)).

## Core SDK Current State

Currently, we do not have a Core SDK for JVM languages. Instead, we offer two separate Pub/Sub channel SDK artifacts:
`io.ably:ably-android` and `io.ably:ably-java`.

These artifacts do not share common interfaces, making it impossible to provide a single,
unified SDK that works with both `io.ably:ably-android` and `io.ably:ably-java`.

## Core SDK Future Improvements

We are planning to define our Core SDK as a Pub/Sub channel SDK without additional plugins like VcDiff, LiveObjects, or Push Notifications.

Our current pub/sub channel SDK will be split into several Maven artifacts:

1. `com.ably.core:api` - Public interfaces for the core SDK (includes `RestClient`, `RealtimeClient`).
2. `com.ably.core:runtime` - Pub/sub channel SDK implementation.
3. `com.ably.core:serialization-*` - Serialization modules (e.g., `com.ably.core:serialization-gson`).
4. `com.ably.core:network-*` - Networking modules (e.g., `com.ably.core:network-okhttp`).
5. `com.ably.core:plugin-*` - Plugin packages (e.g., `com.ably.core:plugin-vc-diff`).
6. `com.ably.core:android-push` - Android Push extensions (push activation, logic). Note that the Push Admin part should be included in the public interface and implemented in `com.ably.core:runtime`.
7. `com.ably.core:android-ext` - Android-specific extensions.

### Dependency on Core SDK

Other products (Spaces, Chat, Asset Tracking, etc.) should depend on `com.ably.core:api` to access the public API and potentially some internal APIs (which should be marked with a special `@InternalApi` annotation).

## Dependency on Third-Party Libraries

We generally try to avoid dependencies on third-party libraries, especially when it comes to networking or serialization libraries. These libraries are often opinionated and can lead to several problems: version incompatibility (e.g., OkHttp 4.x vs. OkHttp 5.x), code inconsistency, and name clashes (e.g., when a project uses `kotlinx.serialization` and we require `Gson`).

When reasonable, we should create the necessary interfaces, hide dependencies behind them, and provide implementations as separate packages.

## Kotlin Coroutines

We want to provide an idiomatic Kotlin API for our customers, and coroutines is currently the idiomatic way to handle asynchronous operations and reactive programming (callbacks, subscriptions).

* Async operations become Kotlin **suspending functions**.
* Generic state changes (usually implemented with an `on()` method) are transformed into `StateFlow`.
* Subscriptions are transformed into either `Flow` or `SharedFlow`.

### Code Examples

```kotlin
val client = RestClient(key = "<ABLY KEY>")
val currentStatus = client.connection.status.value
client.connection.status.collect { nextStatus ->
    // subsribe to status change
    println(nextStatus)
}
```

### Flow (Cold Flow) vs. SharedFlow (Hot Flow)

Consider using `Flow` when:

* Each subscriber should receive an independent sequence of events.
* Events should be produced on-demand, i.e., only when a subscriber is actively collecting the flow.

Consider using `SharedFlow` when:

* Events are produced independently of whether there are active subscribers.
* Multiple subscribers are expected to act on the same stream of events (not independently).

**Note:** When using `SharedFlow`, remember that subscribers act on the same stream of events, and if one subscriber is slow, it can slow down other subscribers.

**Note:** `kotlinx.coroutines` should be considered a third-party library (because it's not part of the Kotlin Standard Library) with some exceptions. It's generally safe to use because modern Android applications (based on Jetpack Compose) usually depend on it. However, if possible, without sacrificing development speed or code readability, we should avoid having a strong dependency on `kotlinx.coroutines` and instead provide an idiomatic flow-based API in a separate coroutine extension package.

## Kotlin Multiplatform

Kotlin Multiplatform technology is designed to simplify the development of cross-platform projects. To enable cross-platform support for your Kotlin SDK, you should depend on the Kotlin Standard Library and third-party libraries with Kotlin Multiplatform support, avoiding JVM-specific functionality (e.g., avoid `java.*` imports in the SDK, `synchronized` blocks, etc.).

More and more libraries are providing Kotlin Multiplatform support. [Android announced](https://android-developers.googleblog.com/2024/05/android-support-for-kotlin-multiplatform-to-share-business-logic-across-mobile-web-server-desktop.html) that they plan to implement Kotlin Multiplatform support for their libraries. Many core Android libraries have already received it, as you can see [here](https://developer.android.com/kotlin/multiplatform#multiplatform-jetpack).

Providing Kotlin Multiplatform support for a library is becoming a best practice in the Kotlin and JVM world. Therefore, when developing a Kotlin SDK, we should consider avoiding `java.*` packages and avoid adding third-party libraries that do not support Kotlin Multiplatform.
