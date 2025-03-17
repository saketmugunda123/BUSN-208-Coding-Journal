import SwiftUI

struct HabitEditView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var frequency = "daily"
    @State private var reminderTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Habit Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Schedule")) {
                    Picker("Frequency", selection: $frequency) {
                        Text("Daily").tag("daily")
                        Text("Weekly").tag("weekly")
                        Text("Monthly").tag("monthly")
                    }
                    
                    DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
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
                .disabled(name.isEmpty)
            )
        }
    }
} 