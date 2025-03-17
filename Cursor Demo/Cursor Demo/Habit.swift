import Foundation

struct HabitCompletion: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}

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
    
    var isCompletedToday: Bool {
        guard let lastCompleted = lastCompletedDate else { return false }
        let calendar = Calendar.current
        let today = Date()
        
        switch frequency {
        case "daily":
            return calendar.isDate(lastCompleted, inSameDayAs: today)
        case "weekly":
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
            return lastCompleted > weekAgo
        case "monthly":
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: today)!
            return lastCompleted > monthAgo
        default:
            return false
        }
    }
}

class HabitStore: ObservableObject {
    @Published var habits: [HabitDetails]
    @Published var completions: [HabitCompletion]
    
    init(habits: [HabitDetails] = [], completions: [HabitCompletion] = []) {
        self.habits = habits
        self.completions = completions
    }
    
    func addHabit(_ habit: HabitDetails) {
        habits.append(habit)
    }
    
    func completeHabit(_ habit: HabitDetails) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].lastCompletedDate = Date()
            completions.append(HabitCompletion())
        }
    }
    
    func getCompletionsForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return completions.filter { completion in
            calendar.isDate(completion.date, inSameDayAs: date)
        }.count
    }
    
    func getCompletionsForLastNDays(_ n: Int) -> [(Date, Int)] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<n).map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            return (date, getCompletionsForDate(date))
        }.reversed()
    }
} 