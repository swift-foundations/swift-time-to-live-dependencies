// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-time-to-live-dependencies open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-time-to-live-dependencies project authors
// Licensed under Apache License 2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Clocks_Dependencies
import Dependencies
public import Time_Primitive
import Time_To_Live
public import Time_To_Live_Store

extension Store.InMemory where Instant == Clock.`Any`<Time_Primitive.Duration>.Instant {
    /// Inserts a value expiring `duration` from the injected clock's current
    /// instant; a `nil` duration never expires.
    public func insert(_ value: Value, forKey key: Key, expiresIn duration: Time_Primitive.Duration? = nil) {
        @Dependency(\.clock) var clock
        insert(value, forKey: key, ttl: TTL(duration, from: clock.now))
    }

    /// Returns the value for a key if it is present and not expired at the
    /// injected clock's current instant, removing it if expired.
    public func value(forKey key: Key) -> Value? {
        @Dependency(\.clock) var clock
        return value(forKey: key, at: clock.now)
    }

    /// Removes every entry expired at the injected clock's current instant.
    public func prune() {
        @Dependency(\.clock) var clock
        prune(at: clock.now)
    }
}
