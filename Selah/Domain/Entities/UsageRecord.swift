//
//  UsageRecord.swift
//  Selah
//
//  Created by James Park on 2026-04-08.
//


import Foundation

struct UsageRecord: Identifiable {
    let id: UUID
    let bundleIdentifier: String
    let duration: TimeInterval
    let date: Date

    init(id: UUID = UUID(), bundleIdentifier: String, duration: TimeInterval, date: Date = .now) {
        self.id = id
        self.bundleIdentifier = bundleIdentifier
        self.duration = duration
        self.date = date
    }
}
