//
//  ContentView.swift
//  Cursor Demo
//
//  Created by Mugunda, Saket on 3/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HabitListView(habitStore: habitStore)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Habits")
            }
            .tag(0)
            
            NavigationView {
                StatsView(habitStore: habitStore)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Stats")
            }
            .tag(1)
        }
    }
}

struct StatsView: View {
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ContributionGraph(data: habitStore.getCompletionsForLastNDays(49))
                    .padding()
            }
        }
        .navigationTitle("Statistics")
    }
}

#Preview {
    ContentView()
}
