import SwiftUI

struct ContributionGraph: View {
    let data: [(Date, Int)]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Activity Calendar")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                Text("Less")
                ForEach(0..<5) { i in
                    Rectangle()
                        .fill(colorForCount(i))
                        .frame(width: 20, height: 20)
                        .cornerRadius(2)
                }
                Text("More")
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(data, id: \.0) { date, count in
                    Rectangle()
                        .fill(colorForCount(count))
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(2)
                        .overlay(
                            Text("\(count)")
                                .font(.caption2)
                                .foregroundColor(count > 0 ? .white : .clear)
                        )
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func colorForCount(_ count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray6)
        case 1: return Color.blue.opacity(0.3)
        case 2: return Color.blue.opacity(0.5)
        case 3: return Color.blue.opacity(0.7)
        default: return Color.blue
        }
    }
} 