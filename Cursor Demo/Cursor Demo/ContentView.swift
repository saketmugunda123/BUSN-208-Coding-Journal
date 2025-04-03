//
//  ContentView.swift
//  Cursor Demo
//
//  Created by Mugunda, Saket on 3/17/25.
//

import SwiftUI

// Main view of the app with tab-based navigation
struct ContentView: View {
    // State object to manage all habits and their completions
    @StateObject private var habitStore = HabitStore()
    // Tracks which tab is currently selected
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // First tab: List of habits
            NavigationView {
                HabitListView(habitStore: habitStore)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Habits")
            }
            .tag(0)
            
            // Second tab: Statistics and progress
            NavigationView {
                StatsView(habitStore: habitStore)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Stats")
            }
            .tag(1)
        }
        .accentColor(Theme.accentColor)
        .preferredColorScheme(.dark)
        .background(Theme.backgroundColor)
    }
}

// View to display habit statistics and progress
struct StatsView: View {
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display the contribution graph showing last 49 days of activity
                ContributionGraph(data: habitStore.getCompletionsForLastNDays(49))
                    .padding()
            }
        }
        .navigationTitle("Statistics")
        .background(Theme.backgroundColor)
    }
}

#Preview {
    ContentView()
}
