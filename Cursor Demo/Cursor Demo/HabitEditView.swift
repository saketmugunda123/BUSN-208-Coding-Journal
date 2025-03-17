import SwiftUI

struct HabitEditView: View {
    @ObservedObject var habit: Habit
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Habit Name", text: $habit.details.name)
                    TextField("Description", text: $habit.details.description)
                }
                
                Section(header: Text("Schedule")) {
                    DatePicker("Target Date", selection: $habit.details.targetDate, displayedComponents: .date)
                    
                    Picker("Frequency", selection: $habit.details.frequency) {
                        Text("Daily").tag("daily")
                        Text("Weekly").tag("weekly")
                        Text("Monthly").tag("monthly")
                    }
                    
                    DatePicker("Reminder Time", selection: Binding(
                        get: { habit.details.reminderTime ?? Date() },
                        set: { habit.details.reminderTime = $0 }
                    ), displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    habit.addCompletion()
                    dismiss()
                }
            )
        }
    }
} 