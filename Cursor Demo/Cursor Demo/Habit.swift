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
    var targetDate: Date
    var frequency: String // daily, weekly, monthly
    var reminderTime: Date?
    
    init(id: UUID = UUID(), name: String = "", description: String = "", targetDate: Date = Date(), frequency: String = "daily", reminderTime: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.targetDate = targetDate
        self.frequency = frequency
        self.reminderTime = reminderTime
    }
}

class Habit: ObservableObject {
    @Published var completions: [HabitCompletion]
    @Published var details: HabitDetails
    
    init(completions: [HabitCompletion] = [], details: HabitDetails = HabitDetails()) {
        self.completions = completions
        self.details = details
    }
    
    func addCompletion() {
        completions.append(HabitCompletion())
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