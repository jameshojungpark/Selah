//
//  FetchTodayUsageUseCaseTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-09.
//

import Testing
import Foundation

@testable import Selah

private final class MockUsageRepository: UsageRepository {
    var todayRecords: [UsageRecord] = []
    var shouldThrow = false

    func fetchTodayUsage() async throws -> [UsageRecord] {
        if shouldThrow { throw MockError.forced }
        return todayRecords
    }

    func fetchWeeklyUsage() async throws -> [UsageRecord] {
        return []
    }
}

private enum MockError: Error {
    case forced
}

struct FetchTodayUsageUseCaseTests {

    @Test("execute returns records sorted by duration descending")
    func executeReturnsSortedByDurationDescending() async throws {
        let repo = MockUsageRepository()
        let low = UsageRecord(bundleIdentifier: "com.example.a", duration: 10)
        let mid = UsageRecord(bundleIdentifier: "com.example.b", duration: 50)
        let high = UsageRecord(bundleIdentifier: "com.example.c", duration: 30)
        repo.todayRecords = [low, mid, high]

        let useCase = FetchTodayUsageUseCaseImpl(repository: repo)
        let result = try await useCase.execute()

        #expect(result.count == 3)
        #expect(result[0].duration == 50)
        #expect(result[1].duration == 30)
        #expect(result[2].duration == 10)
    }

    @Test("execute returns empty array when repository returns no records")
    func executeReturnsEmptyArrayWhenNoRecords() async throws {
        let repo = MockUsageRepository()
        let useCase = FetchTodayUsageUseCaseImpl(repository: repo)

        let result = try await useCase.execute()

        #expect(result.isEmpty)
    }

    @Test("execute propagates repository errors")
    func executePropagatesRepositoryErrors() async {
        let repo = MockUsageRepository()
        repo.shouldThrow = true
        let useCase = FetchTodayUsageUseCaseImpl(repository: repo)

        await #expect(throws: MockError.forced) {
            try await useCase.execute()
        }
    }
}
