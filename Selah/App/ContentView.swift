//
//  ContentView.swift
//  Selah
//
//  Created by James Park on 2026-04-09.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max")
                }

            LimitsView()
                .tabItem {
                    Label("Limits", systemImage: "hourglass")
                }

        }
    }
}
