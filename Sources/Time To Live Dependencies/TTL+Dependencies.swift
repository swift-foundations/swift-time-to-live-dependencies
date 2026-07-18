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
public import Time_To_Live

extension TTL where Instant == Clock.`Any`<Duration>.Instant {
    /// Whether this policy is expired at the injected current instant.
    public func isExpired() -> Bool {
        @Dependency(\.clock) var clock
        return self.isExpired(at: clock.now)
    }
}
