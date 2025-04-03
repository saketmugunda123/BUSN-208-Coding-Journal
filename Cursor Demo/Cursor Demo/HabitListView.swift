import SwiftUI

// Main view for displaying the list of habits
struct HabitListView: View {
    @ObservedObject var habitStore: HabitStore
    // Controls the presentation of the add habit sheet
    @State private var showingAddHabit = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(habitStore.habits) { habit in
                    HabitRow(habit: habit, habitStore: habitStore)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("My Habits")
        .toolbar {
            // Add button to create new habits
            Button(action: {
                showingAddHabit = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Theme.accentColor)
            }
        }
        // Sheet to add new habits
        .sheet(isPresented: $showingAddHabit) {
            HabitEditView(habitStore: habitStore)
        }
        .background(Theme.backgroundColor)
    }
}

// Individual row view for each habit
struct HabitRow: View {
    let habit: HabitDetails
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        HStack {
            // Left side: Habit details
            VStack(alignment: .leading, spacing: 8) {
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                HStack {
                    Image(systemName: frequencyIcon)
                        .foregroundColor(Theme.accentColor)
                    Text("\(habit.frequency.capitalized)")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            // Right side: Completion button
            Button(action: {
                habitStore.completeHabit(habit)
            }) {
                // Show filled circle if completed, empty circle if not
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(habit.isCompletedToday ? Theme.contributionColors[3] : Theme.textSecondary)
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var frequencyIcon: String {
        switch habit.frequency {
        case "daily": return "sun.max.fill"
        case "weekly": return "calendar"
        case "monthly": return "calendar.badge.clock"
        default: return "circle"
        }
    }
} 

