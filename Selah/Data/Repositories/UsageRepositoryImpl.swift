//
//  UsageRepositoryImpl.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//


import Foundation

final class UsageRepositoryImpl: UsageRecordRepository {

    // Replace with DeviceActivity framework
    private var records: [UsageRecord] = []

    func fetchTodayUsage() async throws -> [UsageRecord] {
        let today = Calendar.current.startOfDay(for: .now)
        return records.filter { $0.date >= today }
    }

    func fetchWeeklyUsage() async throws -> [UsageRecord] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        return records.filter { $0.date >= weekAgo }
    }
}
