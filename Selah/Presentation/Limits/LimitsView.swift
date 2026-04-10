//
//  LimitsView.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//

import SwiftUI

struct LimitsView: View {
    @StateObject private var viewModel = LimitsViewModel(
        setLimitUseCase: SetAppLimitUseCaseImpl(
            repository: AppLimitRepositoryImpl()
        )
    )

    @State private var showAddLimit = false
    @State private var bundleIdentifier = ""
    @State private var dailyMinutes = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.limits) { limit in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(limit.bundleIdentifier)
                            .font(.headline)
                        Text("\(limit.dailyMinutes) minutes per day")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        viewModel.removeLimit(id: viewModel.limits[index].id)
                    }
                }
            }
            .navigationTitle("Limits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddLimit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddLimit) {
                AddLimitSheet(
                    bundleIdentifier: $bundleIdentifier,
                    dailyMinutes: $dailyMinutes,
                    onSave: {
                        Task {
                            await viewModel.addLimit(
                                bundleIdentifier: bundleIdentifier,
                                dailyMinutes: Int(dailyMinutes) ?? 0
                            )
                            showAddLimit = false
                            bundleIdentifier = ""
                            dailyMinutes = ""
                        }
                    }
                )
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

struct AddLimitSheet: View {
    @Binding var bundleIdentifier: String
    @Binding var dailyMinutes: String
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Bundle ID (e.g. com.instagram.Instagram)", text: $bundleIdentifier)
                TextField("Daily minutes", text: $dailyMinutes)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Limit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: onSave)
                }
            }
        }
    }
}
