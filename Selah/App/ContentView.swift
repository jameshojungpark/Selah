//
//  ContentView.swift
//  Selah
//
//  Created by 박호정 on 2026-04-09.
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

            Text("Sacred Hours")
                .tabItem {
                    Label("Sacred", systemImage: "moon.stars")
                }

            Text("Reflect")
                .tabItem {
                    Label("Reflect", systemImage: "heart")
                }
        }
    }
}