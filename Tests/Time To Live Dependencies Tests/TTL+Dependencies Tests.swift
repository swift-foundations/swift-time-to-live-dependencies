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

import Clocks_Dependencies
import Dependencies_Test_Support
import Time_To_Live
import Testing

@testable import Time_To_Live_Dependencies

@Suite
struct `TTL Dependencies Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `TTL Dependencies Tests`.Unit {
    @Test
    func `the injected clock supplies the current instant`() {
        let test = Clock.Test()
        let clock = Clock.`Any`(test)
        let start = clock.now
        let policy = TTL<Clock.`Any`<Duration>.Instant>(.seconds(5), from: start)

        withDependencies {
            $0.clock = clock
        } operation: {
            #expect(!policy.isExpired())
            test.advance(by: .seconds(5))
            #expect(policy.isExpired())
        }
    }
}

extension `TTL Dependencies Tests`.`Edge Case` {
    @Test
    func `an absent duration remains unexpired`() {
        let test = Clock.Test()
        let clock = Clock.`Any`(test)
        let policy = TTL<Clock.`Any`<Duration>.Instant>(from: clock.now)

        withDependencies {
            $0.clock = clock
        } operation: {
            #expect(!policy.isExpired())
        }
    }
}
