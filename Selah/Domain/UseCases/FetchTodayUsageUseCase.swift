//
//  FetchTodayUsageUseCase.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//


import Foundation

protocol FetchTodayUsageUseCase {
    func execute() async throws -> [UsageRecord]
}

final class FetchTodayUsageUseCaseImpl: FetchTodayUsageUseCase {
    private let repository: UsageRepository

    init(repository: UsageRepository) {
        self.repository = repository
    }

    func execute() async throws -> [UsageRecord] {
        let records = try await repository.fetchTodayUsage()
        return records.sorted { $0.duration > $1.duration }
    }
}
