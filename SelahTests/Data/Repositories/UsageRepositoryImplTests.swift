//
//  UsageRepositoryImplTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-09.
//

import Testing
import Foundation

@testable import Selah

struct UsageRepositoryImplTests {

    @Test("fetchTodayUsage returns empty when no records exist")
    func fetchTodayUsageReturnsEmptyWhenNoRecords() async throws {
        let repo = UsageRepositoryImpl()

        let result = try await repo.fetchTodayUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchTodayUsage returns records dated today")
    func fetchTodayUsageReturnsTodayRecords() async throws {
        let todayRecord = UsageRecord(bundleIdentifier: "com.example.app", duration: 60, date: .now)
        let repo = UsageRepositoryImpl(records: [todayRecord])

        let result = try await repo.fetchTodayUsage()

        #expect(result.count == 1)
        #expect(result.first?.bundleIdentifier == "com.example.app")
    }

    @Test("fetchTodayUsage excludes records from yesterday")
    func fetchTodayUsageExcludesYesterdayRecords() async throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let oldRecord = UsageRecord(bundleIdentifier: "com.example.old", duration: 30, date: yesterday)
        let repo = UsageRepositoryImpl(records: [oldRecord])

        let result = try await repo.fetchTodayUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchTodayUsage returns only today's records when mixed dates exist")
    func fetchTodayUsageFiltersToToday() async throws {
        let todayRecord = UsageRecord(bundleIdentifier: "com.example.today", duration: 60, date: .now)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let oldRecord = UsageRecord(bundleIdentifier: "com.example.old", duration: 30, date: yesterday)
        let repo = UsageRepositoryImpl(records: [todayRecord, oldRecord])

        let result = try await repo.fetchTodayUsage()

        #expect(result.count == 1)
        #expect(result.first?.bundleIdentifier == "com.example.today")
    }

    @Test("fetchWeeklyUsage returns empty when no records exist")
    func fetchWeeklyUsageReturnsEmptyWhenNoRecords() async throws {
        let repo = UsageRepositoryImpl()

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchWeeklyUsage returns records within the last 7 days")
    func fetchWeeklyUsageReturnsRecordsWithinWeek() async throws {
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        let record = UsageRecord(bundleIdentifier: "com.example.app", duration: 60, date: threeDaysAgo)
        let repo = UsageRepositoryImpl(records: [record])

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.count == 1)
    }

    @Test("fetchWeeklyUsage excludes records older than 7 days")
    func fetchWeeklyUsageExcludesOldRecords() async throws {
        let eightDaysAgo = Calendar.current.date(byAdding: .day, value: -8, to: .now)!
        let oldRecord = UsageRecord(bundleIdentifier: "com.example.old", duration: 30, date: eightDaysAgo)
        let repo = UsageRepositoryImpl(records: [oldRecord])

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.isEmpty)
    }

    @Test("fetchWeeklyUsage returns only records within the last 7 days when mixed dates exist")
    func fetchWeeklyUsageFiltersToWeek() async throws {
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        let eightDaysAgo = Calendar.current.date(byAdding: .day, value: -8, to: .now)!
        let recentRecord = UsageRecord(bundleIdentifier: "com.example.recent", duration: 60, date: threeDaysAgo)
        let oldRecord = UsageRecord(bundleIdentifier: "com.example.old", duration: 30, date: eightDaysAgo)
        let repo = UsageRepositoryImpl(records: [recentRecord, oldRecord])

        let result = try await repo.fetchWeeklyUsage()

        #expect(result.count == 1)
        #expect(result.first?.bundleIdentifier == "com.example.recent")
    }
}
