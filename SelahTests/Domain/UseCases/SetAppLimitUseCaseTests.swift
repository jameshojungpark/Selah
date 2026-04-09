//
//  SetAppLimitUseCaseTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-09.
//

import Testing
import Foundation

@testable import Selah

private final class MockAppLimitRepository: AppLimitRepository {
    var limits: [AppLimit] = []
    var shouldThrow = false

    func fetchAll() async throws -> [AppLimit] {
        if shouldThrow { throw MockError.forced }
        return limits
    }

    func save(_ limit: AppLimit) async throws {
        if shouldThrow { throw MockError.forced }
        if let index = limits.firstIndex(where: { $0.id == limit.id }) {
            limits[index] = limit
        } else {
            limits.append(limit)
        }
    }

    func delete(id: UUID) async throws {
        if shouldThrow { throw MockError.forced }
        limits.removeAll { $0.id == id }
    }
}

private enum MockError: Error {
    case forced
}

struct SetAppLimitUseCaseTests {

    @Test("execute saves a valid limit to the repository")
    func executeSavesValidLimit() async throws {
        let repo = MockAppLimitRepository()
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 60)

        try await useCase.execute(limit)

        #expect(repo.limits.count == 1)
        #expect(repo.limits.first == limit)
    }

    @Test("execute throws invalidMinutes when dailyMinutes is zero")
    func executeThrowsInvalidMinutesWhenZero() async {
        let repo = MockAppLimitRepository()
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 0)

        await #expect(throws: AppLimitError.invalidMinutes) {
            try await useCase.execute(limit)
        }
    }

    @Test("execute throws invalidMinutes when dailyMinutes is negative")
    func executeThrowsInvalidMinutesWhenNegative() async {
        let repo = MockAppLimitRepository()
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: -1)

        await #expect(throws: AppLimitError.invalidMinutes) {
            try await useCase.execute(limit)
        }
    }

    @Test("execute throws exceedsDailyLimit when dailyMinutes exceeds 1440")
    func executeThrowsExceedsDailyLimitWhenOver1440() async {
        let repo = MockAppLimitRepository()
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 1441)

        await #expect(throws: AppLimitError.exceedsDailyLimit) {
            try await useCase.execute(limit)
        }
    }

    @Test("execute accepts boundary value of 1440 minutes")
    func executeAcceptsBoundaryValueOf1440() async throws {
        let repo = MockAppLimitRepository()
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 1440)

        try await useCase.execute(limit)

        #expect(repo.limits.count == 1)
        #expect(repo.limits.first?.dailyMinutes == 1440)
    }

    @Test("execute propagates repository errors")
    func executePropagatesRepositoryErrors() async {
        let repo = MockAppLimitRepository()
        repo.shouldThrow = true
        let useCase = SetAppLimitUseCaseImpl(repository: repo)
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)

        await #expect(throws: MockError.forced) {
            try await useCase.execute(limit)
        }
    }
}
