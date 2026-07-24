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
import Testing
import Time_Primitive
import Time_To_Live_Store

@testable import Time_To_Live_Dependencies

@Suite
struct `Store InMemory Dependencies Tests` {
    @Test
    func `insert expiresIn and value resolve the injected clock`() {
        let test = Clock.Test()
        let clock = Clock.`Any`(test)
        let store = Store.InMemory<String, Int, Clock.`Any`<Time_Primitive.Duration>.Instant>()

        withDependencies {
            $0.clock = clock
        } operation: {
            store.insert(1, forKey: "a", expiresIn: .seconds(10))
            #expect(store.value(forKey: "a") == 1)

            test.advance(by: .seconds(20))
            #expect(store.value(forKey: "a") == nil)
        }
    }

    @Test
    func `an absent duration never expires`() {
        let test = Clock.Test()
        let clock = Clock.`Any`(test)
        let store = Store.InMemory<String, Int, Clock.`Any`<Time_Primitive.Duration>.Instant>()

        withDependencies {
            $0.clock = clock
        } operation: {
            store.insert(7, forKey: "eternal")  // expiresIn defaults to nil

            test.advance(by: .seconds(10_000))
            #expect(store.value(forKey: "eternal") == 7)
        }
    }

    @Test
    func `prune drops entries expired at the injected instant`() {
        let test = Clock.Test()
        let clock = Clock.`Any`(test)
        let store = Store.InMemory<String, Int, Clock.`Any`<Time_Primitive.Duration>.Instant>()

        withDependencies {
            $0.clock = clock
        } operation: {
            store.insert(1, forKey: "short", expiresIn: .seconds(10))
            store.insert(2, forKey: "long", expiresIn: .seconds(100))

            test.advance(by: .seconds(50))
            store.prune()

            #expect(store.count == 1)
            #expect(store.value(forKey: "long") == 2)
        }
    }
}
