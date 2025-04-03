import SwiftUI

// View that displays a GitHub-style contribution graph
struct ContributionGraph: View {
    let data: [(Date, Int)] // Array of (date, completion count) tuples
    // Grid layout with 7 columns (one for each day of the week)
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title of the graph
            Text("Activity Calendar")
                .font(.headline)
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal)
            
            // Legend showing activity levels
            HStack {
                Text("Less")
                    .foregroundColor(Theme.textSecondary)
                ForEach(0..<5) { i in
                    Rectangle()
                        .fill(Theme.contributionColors[i])
                        .frame(width: 20, height: 20)
                        .cornerRadius(2)
                }
                Text("More")
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.horizontal)
            
            // Grid of completion squares
            GeometryReader { geometry in
                let squareSize = min(geometry.size.width / 7, geometry.size.height / 7)
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(data, id: \.0) { date, count in
                        Rectangle()
                            .fill(Theme.contributionColors[min(count, 4)])
                            .frame(width: squareSize, height: squareSize)
                            .cornerRadius(2)
                            // Show completion count on squares with activity
                            .overlay(
                                Text("\(count)")
                                    .font(.caption2)
                                    .foregroundColor(count > 0 ? Theme.textPrimary : .clear)
                            )
                    }
                }
                .padding()
            }
            .frame(height: 300) // Fixed height for the grid
        }
        .cardStyle()
    }
} 