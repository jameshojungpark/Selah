//
//  UsageRepository.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//


import Foundation

protocol SetAppLimitUseCase {
    func execute(_ limit: AppLimit) async throws
}

final class SetAppLimitUseCaseImpl: SetAppLimitUseCase {
    private let repository: AppLimitRepository

    init(repository: AppLimitRepository) {
        self.repository = repository
    }

    func execute(_ limit: AppLimit) async throws {
        guard limit.dailyMinutes > 0 else {
            throw AppLimitError.invalidMinutes
        }
        guard limit.dailyMinutes <= 1440 else {
            throw AppLimitError.exceedsDailyLimit
        }
        try await repository.save(limit)
    }
}

enum AppLimitError: Error {
    case invalidMinutes
    case exceedsDailyLimit
}
