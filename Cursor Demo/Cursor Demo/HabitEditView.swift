import SwiftUI

// View for creating and editing habits
struct HabitEditView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) var dismiss
    
    // Form state variables
    @State private var name = ""
    @State private var description = ""
    @State private var frequency = "daily"
    @State private var reminderTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                // Basic information section
                Section(header: Text("Basic Information")
                    .foregroundColor(Theme.textSecondary)) {
                    TextField("Habit Name", text: $name)
                        .foregroundColor(Theme.textPrimary)
                    TextField("Description", text: $description)
                        .foregroundColor(Theme.textPrimary)
                }
                
                // Schedule section
                Section(header: Text("Schedule")
                    .foregroundColor(Theme.textSecondary)) {
                    // Frequency picker (daily/weekly/monthly)
                    Picker("Frequency", selection: $frequency) {
                        Text("Daily").tag("daily")
                        Text("Weekly").tag("weekly")
                        Text("Monthly").tag("monthly")
                    }
                    .foregroundColor(Theme.textPrimary)
                    
                    // Time picker for daily reminders
                    DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .foregroundColor(Theme.textPrimary)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarItems(
                // Cancel button to dismiss the sheet
                leading: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Theme.accentColor),
                // Save button to create the new habit
                trailing: Button("Save") {
                    let newHabit = HabitDetails(
                        name: name,
                        description: description,
                        frequency: frequency,
                        reminderTime: reminderTime
                    )
                    habitStore.addHabit(newHabit)
                    dismiss()
                }
                .foregroundColor(Theme.accentColor)
                .disabled(name.isEmpty) // Disable save if name is empty
            )
        }
        .preferredColorScheme(.dark)
        .background(Theme.backgroundColor)
    }
} 