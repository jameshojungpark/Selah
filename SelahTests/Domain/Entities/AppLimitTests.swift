//
//  AppLimitTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-08.
//

import Testing
import Foundation

@testable import Selah

struct AppLimitTests {

    @Test func defaultInitializerSetsActiveTrue() {
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)
        #expect(limit.isActive == true)
    }

    @Test func initializerAssignsProperties() {
        let id = UUID()
        let limit = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 60, isActive: false)
        #expect(limit.id == id)
        #expect(limit.bundleIdentifier == "com.example.app")
        #expect(limit.dailyMinutes == 60)
        #expect(limit.isActive == false)
    }

    @Test func defaultIdIsUnique() {
        let first = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 10)
        let second = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 10)
        #expect(first.id != second.id)
    }

    @Test func equalityComparesAllProperties() {
        let id = UUID()
        let a = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 30, isActive: true)
        let b = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 30, isActive: true)
        #expect(a == b)
    }

    @Test func inequalityWhenPropertiesDiffer() {
        let id = UUID()
        let a = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 30, isActive: true)
        let b = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 60, isActive: true)
        #expect(a != b)
    }
}
