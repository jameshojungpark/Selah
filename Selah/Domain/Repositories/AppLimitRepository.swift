//
//  AppLimitRepository.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//

import Foundation

protocol AppLimitRepository {
    func fetchAll() async throws -> [AppLimit]
    func save(_ limit: AppLimit) async throws
    func delete(id: UUID) async throws
}
