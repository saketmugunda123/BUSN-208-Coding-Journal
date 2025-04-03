import SwiftUI

// Theme colors and styling for the app
struct Theme {
    static let backgroundColor = Color(red: 13/255, green: 17/255, blue: 23/255)
    static let cardBackground = Color(red: 22/255, green: 27/255, blue: 34/255)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 139/255, green: 148/255, blue: 158/255)
    
    static let contributionColors: [Color] = [
        Color(red: 39/255, green: 34/255, blue: 21/255),  // Level 0
        Color(red: 9/255, green: 105/255, blue: 3/255),    // Level 1
        Color(red: 26/255, green: 127/255, blue: 22/255),  // Level 2
        Color(red: 64/255, green: 196/255, blue: 60/255),  // Level 3
        Color(red: 108/255, green: 169/255, blue: 101/255) // Level 4
    ]
    
    static let accentColor = Color(red: 58/255, green: 139/255, blue: 255/255)
    
    static let cardStyle: some ViewModifier = CardModifier()
}

// Modifier for card styling
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Theme.cardBackground)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// Extension to make the modifier easier to use
extension View {
    func cardStyle() -> some View {
        modifier(Theme.cardStyle)
    }
} 