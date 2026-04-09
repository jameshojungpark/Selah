//
//  UsageRecordRepositoryTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-09.
//

import Testing
import Foundation

@testable import Selah

private final class MockUsageRecordRepository: UsageRecordRepository {
    var todayRecords: [UsageRecord] = []
    var weeklyRecords: [UsageRecord] = []
    var shouldThrow = false

    func fetchTodayUsage() async throws -> [UsageRecord] {
        if shouldThrow { throw MockError.forced }
        return todayRecords
    }

    func fetchWeeklyUsage() async throws -> [UsageRecord] {
        if shouldThrow { throw MockError.forced }
        return weeklyRecords
    }
}

private enum MockError: Error {
    case forced
}

struct UsageRecordRepositoryTests {

    @Test("fetchTodayUsage returns today's records")
    func fetchTodayUsageReturnsRecords() async throws {
        let repo = MockUsageRecordRepository()
        let record = UsageRecord(bundleIdentifier: "com.example.app", duration: 120)
        repo.todayRecords = [record]

        let result = try await repo.fetchTodayUsage()

        #expect(result.count == 1)
        #expect(result.first?.bundleIdentifier == "com.example.app")
    }

    @Test("fetchTodayUsage returns empty when no records exist")
    func fetchTodayUsageReturnsEmpty() async throws {
        let repo = MockUsageRecordRepository()

        let result = try await repo.fetchTodayUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchWeeklyUsage returns weekly records")
    func fetchWeeklyUsageReturnsRecords() async throws {
        let repo = MockUsageRecordRepository()
        let a = UsageRecord(bundleIdentifier: "com.example.a", duration: 60)
        let b = UsageRecord(bundleIdentifier: "com.example.b", duration: 90)
        repo.weeklyRecords = [a, b]

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.count == 2)
    }

    @Test("fetchWeeklyUsage returns empty when no records exist")
    func fetchWeeklyUsageReturnsEmpty() async throws {
        let repo = MockUsageRecordRepository()

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchTodayUsage propagates errors")
    func fetchTodayUsagePropagatesErrors() async {
        let repo = MockUsageRecordRepository()
        repo.shouldThrow = true

        await #expect(throws: MockError.forced) {
            try await repo.fetchTodayUsage()
        }
    }

    @Test("fetchWeeklyUsage propagates errors")
    func fetchWeeklyUsagePropagatesErrors() async {
        let repo = MockUsageRecordRepository()
        repo.shouldThrow = true

        await #expect(throws: MockError.forced) {
            try await repo.fetchWeeklyUsage()
        }
    }
}
