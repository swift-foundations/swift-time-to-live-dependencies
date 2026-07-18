# swift-time-to-live-dependencies

![Development Status](https://img.shields.io/badge/status-active--development-orange.svg)

Dependency-backed access to a `TTL` policy's current instant.

## Overview

`import Time_To_Live_Dependencies` adds `TTL.isExpired()`, which resolves the
current instant from `@Dependency(\.clock)` and delegates expiry evaluation to
the `Time To Live` package. The core `TTL` policy remains responsible for its
optional expiration and explicit start instant.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-time-to-live-dependencies.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Time To Live Dependencies", package: "swift-time-to-live-dependencies")
    ]
)
```

## Quick Start

```swift
import Time_To_Live_Dependencies

@Dependency(\.clock) var clock
let policy = TTL<Clock.`Any`<Duration>.Instant>(.seconds(60), from: clock.now)
guard !policy.isExpired() else { return }
```

Override `\.clock` in tests through `swift-dependencies` for deterministic
expiry checks.

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
