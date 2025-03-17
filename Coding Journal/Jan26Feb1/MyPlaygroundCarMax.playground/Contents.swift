
//Created a simple car class that takes certain members
class Car {
    let name: String
    let horsepower: Int
    let fuelEfficiency: Double  // MPG
    let isSportsCar: Bool
    
    //Initiating the variables within the Car class
    init(name: String, horsepower: Int, fuelEfficiency: Double, isSportsCar: Bool) {
        self.name = name
        self.horsepower = horsepower
        self.fuelEfficiency = fuelEfficiency
        self.isSportsCar = isSportsCar
    }
}

//Antoher class for userprefrences (for a particular user)
class UserPreferences {
    let likesSportsCars: Bool
    let caresAboutGasCost: Bool
    
    //Initiation
    init(likesSportsCars: Bool, caresAboutGasCost: Bool) {
        self.likesSportsCars = likesSportsCars
        self.caresAboutGasCost = caresAboutGasCost
    }
}


//This class containes the function of actaully comparing cars
class CarComparator {
    static func calculateScore(for car: Car, preferences: UserPreferences) -> Double {
        var score = 0.0
        
        if preferences.likesSportsCars {
            score += car.isSportsCar ? 100 : 0
        }
        
        if preferences.caresAboutGasCost {
            score += car.fuelEfficiency
        }
        
        score += Double(car.horsepower) / 10  // Normalize horsepower impact
        
        return score
    }
}
