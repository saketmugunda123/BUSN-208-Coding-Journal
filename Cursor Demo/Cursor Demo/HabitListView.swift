import SwiftUI

struct HabitListView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var showingAddHabit = false
    
    var body: some View {
        List {
            ForEach(habitStore.habits) { habit in
                HabitRow(habit: habit, habitStore: habitStore)
            }
        }
        .navigationTitle("My Habits")
        .toolbar {
            Button(action: {
                showingAddHabit = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            HabitEditView(habitStore: habitStore)
        }
    }
}

struct HabitRow: View {
    let habit: HabitDetails
    @ObservedObject var habitStore: HabitStore
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Frequency: \(habit.frequency.capitalized)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                habitStore.completeHabit(habit)
            }) {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(habit.isCompletedToday ? .green : .gray)
            }
        }
        .padding(.vertical, 4)
    }
} 