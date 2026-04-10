//
//  AppLimitRepositoryImplTests.swift
//  SelahTests
//
//  Created by James Park on 2026-04-09.
//

import Testing
import Foundation

@testable import Selah

struct AppLimitRepositoryImplTests {

    @Test("fetchAll returns empty array on init")
    func fetchAllReturnsEmptyOnInit() async throws {
        let repo = AppLimitRepositoryImpl()

        let result = try await repo.fetchAll()

        #expect(result.isEmpty)
    }

    @Test("save appends a new limit")
    func saveAppendsNewLimit() async throws {
        let repo = AppLimitRepositoryImpl()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)

        try await repo.save(limit)
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
        #expect(result.first == limit)
    }

    @Test("save updates an existing limit with the same id")
    func saveUpdatesExistingLimit() async throws {
        let repo = AppLimitRepositoryImpl()
        let id = UUID()
        let original = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 30)
        let updated = AppLimit(id: id, bundleIdentifier: "com.example.app", dailyMinutes: 90)

        try await repo.save(original)
        try await repo.save(updated)
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
        #expect(result.first?.dailyMinutes == 90)
    }

    @Test("save multiple limits with different ids")
    func saveMultipleLimits() async throws {
        let repo = AppLimitRepositoryImpl()
        let a = AppLimit(bundleIdentifier: "com.example.a", dailyMinutes: 30)
        let b = AppLimit(bundleIdentifier: "com.example.b", dailyMinutes: 60)

        try await repo.save(a)
        try await repo.save(b)
        let result = try await repo.fetchAll()

        #expect(result.count == 2)
    }

    @Test("delete removes the limit with the given id")
    func deleteRemovesLimit() async throws {
        let repo = AppLimitRepositoryImpl()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)

        try await repo.save(limit)
        try await repo.delete(id: limit.id)
        let result = try await repo.fetchAll()

        #expect(result.isEmpty)
    }

    @Test("delete does nothing when id does not exist")
    func deleteNonExistentIdDoesNothing() async throws {
        let repo = AppLimitRepositoryImpl()
        let limit = AppLimit(bundleIdentifier: "com.example.app", dailyMinutes: 30)

        try await repo.save(limit)
        try await repo.delete(id: UUID())
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
    }

    @Test("delete only removes the matching limit")
    func deleteOnlyRemovesMatchingLimit() async throws {
        let repo = AppLimitRepositoryImpl()
        let a = AppLimit(bundleIdentifier: "com.example.a", dailyMinutes: 30)
        let b = AppLimit(bundleIdentifier: "com.example.b", dailyMinutes: 60)

        try await repo.save(a)
        try await repo.save(b)
        try await repo.delete(id: a.id)
        let result = try await repo.fetchAll()

        #expect(result.count == 1)
        #expect(result.first == b)
    }
}
