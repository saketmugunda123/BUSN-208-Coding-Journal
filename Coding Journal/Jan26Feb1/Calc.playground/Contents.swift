import Foundation

//Just a really basic calculator to get used to OOP again
class Calculator {
    
    // Addtion
    func add(_ a: Double, _ b: Double) -> Double {
        return a + b
    }
    
    // Subtract
    func subtract(_ a: Double, _ b: Double) -> Double {
        return a - b
    }
    
    // Mult
    func multiply(_ a: Double, _ b: Double) -> Double {
        return a * b
    }
    
    // Div
    func divide(_ a: Double, _ b: Double) -> Double {
        //A little 0 div error
        if b == 0 {
            print("Error: Division by zero is not allowed.")
            return 0
        }
        return a / b
    }
}

// Example usage
let calc = Calculator()

// Test calculations
print("Addition: \(calc.add(10, 5))")       // 15
print("Subtraction: \(calc.subtract(10, 5))") // 5
print("Multiplication: \(calc.multiply(10, 5))") // 50
print("Division: \(calc.divide(10, 5))")   // 2
print("Division by zero: \(calc.divide(10, 0))") // Error message, returns 0

