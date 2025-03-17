import SwiftUI


//This code represents a potential front end design for a project I have been creating which is a ML Call of Duty Stats Predictor


struct ContentView: View {
    let parlayOptions = [2, 3, 4, 5, 6]  //Parlay sizes that are available on prizepicks
    
    // Hardcoded plays and odds for now (the ML model will output these)
    let plays = [
        2: ("Scump + Dashy", 1.8),
        3: ("Simp + Shotzzy + Cellium", 2.5),
        4: ("All-Star Team", 3.1),
        5: ("JimmyJohn Gods", 3.8),
        6: ("The Shmurdas", 4.2)
    ]
    
    @State private var selectedParlaySize: Int? = nil
    @State private var outputPlay: String = ""
    @State private var cumulativeOdds: Double = 0.0

    var body: some View {
        NavigationView {
            //Creating the v stack for the predictor
            VStack {
                Text("Call of Duty Parlay Predictor")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // This is the actual selection of the parlay size
                Picker("Select Parlay Size", selection: $selectedParlaySize) {
                    ForEach(parlayOptions, id: \.self) { size in
                        Text("\(size)-Man Parlay").tag(size as Int?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Predict Button (this button is there but doesn't have any functionality bc its an outline for what I will be creating later)
                Button(action: fetchParlayDetails) {
                    Text("Get Parlay")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedParlaySize == nil)  // This occurs when a size isn't selected
                
                
                if !outputPlay.isEmpty {
                    Text("Recommended Play: \(outputPlay)")
                        .font(.headline)
                        .padding()
                    Text("Cumulative Odds: \(String(format: "%.2f", cumulativeOdds))")
                        .font(.subheadline)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("COD Parlay Predictor")
        }
    }
    
    // get parlay details based on what size the user selects
    func fetchParlayDetails() {
        guard let parlaySize = selectedParlaySize else { return }
        
        // Get the odds and picks for the selected parlay size (2 man to 6 man)
        if let play = plays[parlaySize] {
            outputPlay = play.0  // Play name
            cumulativeOdds = play.1  // Odds
        } else {
            outputPlay = "No play available"
            cumulativeOdds = 0.0
        }
    }
}

// preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

