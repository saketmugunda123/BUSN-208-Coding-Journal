import SwiftUI

//This is some high level frontend for a ML meal recommeder project I am creating
struct ContentView: View {
    //temp hard coded meals
    let meals: [String: [String]] = [
        "Breakfast": ["Pancakes", "Omelette", "Smoothie Bowl", "Avocado Toast"],
        "Lunch": ["Grilled Chicken Salad", "Pasta Primavera", "Sushi Roll", "Burger & Fries"],
        "Dinner": ["Steak & Mashed Potatoes", "Salmon & Quinoa", "Vegetable Stir-Fry", "Tacos"]
    ]
    
    //prompt for the button to get the meal
    @State private var selectedMeal: String = "Click a button to get a meal!"
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text(selectedMeal)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //Instead of using a vstack, used an Hstack which is a horizontal stack
            HStack(spacing: 20) {
                ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { mealType in
                    Button(mealType) {
                        if let options = meals[mealType] {
                            selectedMeal = options.randomElement() ?? "No meal found"
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}


