//
//  LimitsViewModel.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//

import Foundation

@MainActor
final class LimitsViewModel: ObservableObject {
    @Published var limits: [AppLimit] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let setLimitUseCase: SetAppLimitUseCase

    init(setLimitUseCase: SetAppLimitUseCase) {
        self.setLimitUseCase = setLimitUseCase
    }

    func addLimit(bundleIdentifier: String, dailyMinutes: Int) async {
        isLoading = true
        defer { isLoading = false }

        let limit = AppLimit(bundleIdentifier: bundleIdentifier, dailyMinutes: dailyMinutes)
        do {
            try await setLimitUseCase.execute(limit)
            limits.append(limit)
        } catch AppLimitError.invalidMinutes {
            errorMessage = "Daily minutes must be greater than 0."
        } catch AppLimitError.exceedsDailyLimit {
            errorMessage = "Daily minutes cannot exceed 1440."
        } catch {
            errorMessage = "Something went wrong."
        }
    }

    func removeLimit(id: UUID) {
        limits.removeAll { $0.id == id }
    }
}
