//
//  AppLimit.swift
//  Selah
//
//  Created by James Park on 2026-04-08.
//

import Foundation

struct AppLimit: Identifiable, Equatable{
    let id: UUID
    var bundleIdentifier: String
    var dailyMinutes: Int
    var isActive: Bool
    
    init(id: UUID = UUID(), bundleIdentifier: String, dailyMinutes: Int, isActive: Bool = true){
        self.id = id
        self.bundleIdentifier = bundleIdentifier
        self.dailyMinutes = dailyMinutes
        self.isActive = isActive
    }
}
