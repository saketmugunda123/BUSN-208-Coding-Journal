import SwiftUI

//enum for car makes
enum CarMake: String, CaseIterable, Identifiable {
    case Toyota, Honda, Ford, BMW, Tesla
    var id: String { self.rawValue }
}

//enum for car mdodels
enum CarModel: String, CaseIterable, Identifiable {
    case Sedan, SUV, Truck, Coupe, Electric
    var id: String { self.rawValue }
}

//Was getting an concurrency error and couldn't really figure it out so Claude suggested I use @Main Actor
// Thread-safe Selection Tracker using @MainActor
@MainActor final class CarSelectionManager: ObservableObject {
    // Use a shared instance pattern instead of static properties
    static let shared = CarSelectionManager()
    
    @Published var selectedMake: CarMake? = nil
    @Published var selectedModel: CarModel? = nil
    
    private init() {}
}

class CarSelection {
    private init() {}
    
    static func saveSelection(make: CarMake?, model: CarModel?) {
        UserDefaults.standard.set(make?.rawValue, forKey: "selectedMake")
        UserDefaults.standard.set(model?.rawValue, forKey: "selectedModel")
    }
    
    //loading the makes and models
    static func loadMake() -> CarMake? {
        guard let makeString = UserDefaults.standard.string(forKey: "selectedMake") else {
            return nil
        }
        return CarMake(rawValue: makeString)
    }
    
    static func loadModel() -> CarModel? {
        guard let modelString = UserDefaults.standard.string(forKey: "selectedModel") else {
            return nil
        }
        return CarModel(rawValue: modelString)
    }
}

struct ContentView: View {
    @State private var selectedMake: CarMake? = nil
    @State private var selectedModel: CarModel? = nil
    
    // these are the actual displayed sections
    @State private var savedMake: CarMake? = CarSelection.loadMake()
    @State private var savedModel: CarModel? = CarSelection.loadModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("CarMax Car Selector")
                    .font(.title)
                    .padding()
                
                //selecting a make and model using pickers
                Picker("Select Make", selection: $selectedMake) {
                    Text("Select a make").tag(nil as CarMake?)
                    ForEach(CarMake.allCases) { make in
                        Text(make.rawValue).tag(make as CarMake?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
              
                Picker("Select Model", selection: $selectedModel) {
                    Text("Select a model").tag(nil as CarModel?)
                    ForEach(CarModel.allCases) { model in
                        Text(model.rawValue).tag(model as CarModel?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                // this is the actualy display section of th code
                if let make = selectedMake, let model = selectedModel {
                    Text("You selected: \(make.rawValue) \(model.rawValue)")
                        .font(.headline)
                        .padding()
                    
                    // Updating the user selection (save selection button) but updating vars savedMake and savedmodel
                    Button("Save Selection") {
                        CarSelection.saveSelection(make: make, model: model)
                        savedMake = make
                        savedModel = model
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                if let make = savedMake, let model = savedModel {
                    Text("Saved selection: \(make.rawValue) \(model.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Car Selection")
            .onAppear {
                // Load saved selections when the view appears
                savedMake = CarSelection.loadMake()
                savedModel = CarSelection.loadModel()
            }
        }
    }
}


//Preview for the actual val
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
