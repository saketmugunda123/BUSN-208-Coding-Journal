import Foundation

// Represents a single completion of a habit with a timestamp
struct HabitCompletion: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}

// Represents the details and state of a habit
struct HabitDetails: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var frequency: String // daily, weekly, monthly
    var reminderTime: Date?
    var lastCompletedDate: Date?
    
    init(id: UUID = UUID(), name: String = "", description: String = "", frequency: String = "daily", reminderTime: Date? = nil, lastCompletedDate: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.frequency = frequency
        self.reminderTime = reminderTime
        self.lastCompletedDate = lastCompletedDate
    }
    
    // Determines if the habit is completed for the current period based on its frequency
    var isCompletedToday: Bool {
        guard let lastCompleted = lastCompletedDate else { return false }
        let calendar = Calendar.current
        let today = Date()
        
        switch frequency {
        case "daily":
            // Check if completed today
            return calendar.isDate(lastCompleted, inSameDayAs: today)
        case "weekly":
            // Check if completed within the last 7 days
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
            return lastCompleted > weekAgo
        case "monthly":
            // Check if completed within the last month
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: today)!
            return lastCompleted > monthAgo
        default:
            return false
        }
    }
}

// Manages the collection of habits and their completions
class HabitStore: ObservableObject {
    @Published var habits: [HabitDetails]
    @Published var completions: [HabitCompletion]
    
    init(habits: [HabitDetails] = [], completions: [HabitCompletion] = []) {
        self.habits = habits
        self.completions = completions
    }
    
    // Adds a new habit to the collection
    func addHabit(_ habit: HabitDetails) {
        habits.append(habit)
    }
    
    // Marks a habit as completed and records the completion
    func completeHabit(_ habit: HabitDetails) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].lastCompletedDate = Date()
            completions.append(HabitCompletion())
        }
    }
    
    // Returns the number of completions for a specific date
    func getCompletionsForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return completions.filter { completion in
            calendar.isDate(completion.date, inSameDayAs: date)
        }.count
    }
    
    // Returns completion data for the last N days
    func getCompletionsForLastNDays(_ n: Int) -> [(Date, Int)] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<n).map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            return (date, getCompletionsForDate(date))
        }.reversed()
    }
} 