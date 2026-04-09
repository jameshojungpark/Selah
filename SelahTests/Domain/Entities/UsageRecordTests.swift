//
//  UsageRecordTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-08.
//

import Testing
import Foundation

@testable import Selah

struct UsageRecordTests {

    @Test("Default initializer generates a unique id and uses current date")
    func defaultInitializerUsesDefaults() {
        let before = Date()
        let record = UsageRecord(bundleIdentifier: "com.example.app", duration: 120)
        let after = Date()

        #expect(record.bundleIdentifier == "com.example.app")
        #expect(record.duration == 120)
        #expect(record.date >= before && record.date <= after)
    }

    @Test("Initializer correctly assigns all properties")
    func initializerAssignsProperties() {
        let id = UUID()
        let date = Date(timeIntervalSince1970: 1_000_000)
        let record = UsageRecord(id: id, bundleIdentifier: "com.example.app", duration: 300, date: date)

        #expect(record.id == id)
        #expect(record.bundleIdentifier == "com.example.app")
        #expect(record.duration == 300)
        #expect(record.date == date)
    }

    @Test("Default id is unique across instances")
    func defaultIdIsUnique() {
        let first = UsageRecord(bundleIdentifier: "com.example.app", duration: 60)
        let second = UsageRecord(bundleIdentifier: "com.example.app", duration: 60)
        #expect(first.id != second.id)
    }

    @Test("Duration stores fractional seconds accurately")
    func durationStoresFractionalSeconds() {
        let record = UsageRecord(bundleIdentifier: "com.example.app", duration: 90.5)
        #expect(record.duration == 90.5)
    }
}
