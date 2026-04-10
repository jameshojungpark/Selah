//
//  TodayViewModel.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//

import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published var usageRecords: [UsageRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchTodayUsageUseCase: FetchTodayUsageUseCase

    init(fetchTodayUsageUseCase: FetchTodayUsageUseCase) {
        self.fetchTodayUsageUseCase = fetchTodayUsageUseCase
    }

    func loadTodayUsage() async {
        isLoading = true
        defer { isLoading = false }

        do {
            usageRecords = try await fetchTodayUsageUseCase.execute()
        } catch {
            errorMessage = "Failed to load usage data."
        }
    }

    // 초 → "47m 30s" 형식으로 변환
    func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
}
