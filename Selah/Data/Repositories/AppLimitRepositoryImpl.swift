//
//  AppLimitRepositoryImpl.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//


import Foundation

final class AppLimitRepositoryImpl: AppLimitRepository {

    // temporarily save in local (swith to SwiftData / ManagedSettings로 교체)
    private var limits: [AppLimit] = []

    func fetchAll() async throws -> [AppLimit] {
        return limits
    }

    func save(_ limit: AppLimit) async throws {
        if let index = limits.firstIndex(where: { $0.id == limit.id }) {
            limits[index] = limit
        } else {
            limits.append(limit)
        }
    }

    func delete(id: UUID) async throws {
        limits.removeAll { $0.id == id }
    }
}
