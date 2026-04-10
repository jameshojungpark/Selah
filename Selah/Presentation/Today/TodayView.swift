//
//  TodayView.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel(
        fetchTodayUsageUseCase: FetchTodayUsageUseCaseImpl(
            repository: UsageRepositoryImpl()
        )
    )

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.usageRecords.isEmpty {
                    ContentUnavailableView(
                        "No Usage Data",
                        systemImage: "chart.bar",
                        description: Text("Your app usage will appear here.")
                    )
                } else {
                    List(viewModel.usageRecords) { record in
                        HStack {
                            Text(record.bundleIdentifier)
                                .font(.headline)
                            Spacer()
                            Text(viewModel.formattedDuration(record.duration))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Today")
        }
        .task {
            await viewModel.loadTodayUsage()
        }
    }
}
