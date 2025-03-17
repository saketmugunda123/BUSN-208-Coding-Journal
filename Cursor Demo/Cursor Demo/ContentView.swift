//
//  ContentView.swift
//  Cursor Demo
//
//  Created by Mugunda, Saket on 3/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habit = Habit()
    @State private var showingStats = false
    @State private var showingHabitEdit = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Habit Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if !habit.details.name.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(habit.details.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(habit.details.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Frequency: \(habit.details.frequency.capitalized)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        showingStats = true
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingHabitEdit = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        habit.addCompletion()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .padding()
            .navigationBarHidden(true)
            .sheet(isPresented: $showingStats) {
                StatsView(habit: habit)
            }
            .sheet(isPresented: $showingHabitEdit) {
                HabitEditView(habit: habit)
            }
        }
    }
}

struct StatsView: View {
    @ObservedObject var habit: Habit
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ContributionGraph(data: habit.getCompletionsForLastNDays(49))
                        .padding()
                }
            }
            .navigationTitle("Habit Statistics")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

#Preview {
    ContentView()
}
