//
//  UsageRepository.swift
//  Selah
//
//  Created by 박호정 on 2026-04-09.
//


import Foundation

protocol UsageRepository {
    func fetchTodayUsage() async throws -> [UsageRecord]
    func fetchWeeklyUsage() async throws -> [UsageRecord]
}