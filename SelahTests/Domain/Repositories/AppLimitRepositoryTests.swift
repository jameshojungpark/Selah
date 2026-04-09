//
//  AppLimitRepositoryTests.swift
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

struct AppLimitRepositoryTests {

    @Test("fetchAll returns all saved limits")
    func fetchAllReturnsSavedLimits() async throws {
        let repo = MockAppLimitRepository()
        let a = AppLimit(bundleIdentifier: "com.example.a", dailyMinutes: 30)
        let b = AppLimit(bundleIdentifier: "com.example.b", dailyMinutes: 60)
        repo.limits = [a, b]

        let result = try await repo.fetchAll()

        #expect(result.count == 2)
        #expect(result.contains(a))
        #expect(result.contains(b))
    }

    @Test("save appends a new limit")
    func saveAppendsNewLimit() async throws {
        let repo = MockAppLimitRepository()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 45)

        try await repo.save(limit)
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
        #expect(result.first == limit)
    }

    @Test("save updates an existing limit with the same id")
    func saveUpdatesExistingLimit() async throws {
        let repo = MockAppLimitRepository()
        let id = UUID()
        let original = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 30)
        let updated = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 90)

        try await repo.save(original)
        try await repo.save(updated)
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
        #expect(result.first?.dailyMinutes == 90)
    }

    @Test("delete removes the limit with the given id")
    func deleteRemovesLimit() async throws {
        let repo = MockAppLimitRepository()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)
        repo.limits = [limit]

        try await repo.delete(id: limit.id)
        let result = try await repo.fetchAll()

        #expect(result.isEmpty)
    }

    @Test("delete does nothing when id does not exist")
    func deleteNonExistentIdDoesNothing() async throws {
        let repo = MockAppLimitRepository()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)
        repo.limits = [limit]

        try await repo.delete(id: UUID())
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
    }

    @Test("fetchAll propagates errors")
    func fetchAllPropagatesErrors() async {
        let repo = MockAppLimitRepository()
        repo.shouldThrow = true

        await #expect(throws: MockError.forced) {
            try await repo.fetchAll()
        }
    }

    @Test("save propagates errors")
    func savePropagatesErrors() async {
        let repo = MockAppLimitRepository()
        repo.shouldThrow = true
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)

        await #expect(throws: MockError.forced) {
            try await repo.save(limit)
        }
    }

    @Test("delete propagates errors")
    func deletePropagatesErrors() async {
        let repo = MockAppLimitRepository()
        repo.shouldThrow = true

        await #expect(throws: MockError.forced) {
            try await repo.delete(id: UUID())
        }
    }
}
