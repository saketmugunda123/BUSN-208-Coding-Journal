// Class representing a user in the app
class User {
    var name: String
    var balance: Float
    
    // Initializer members
    init(name: String, balance: Float = 0.0) {
        self.name = name
        self.balance = balance
    }
}

// Class representing an expense in the app
class Expense {
    var amount: Float
    var payer: User
    var participants: [User] // List of people who participated in the expense (including the payer)
    
    // Initializing members
    init(amount: Float, payer: User, participants: [User]) {
        self.amount = amount
        self.payer = payer
        self.participants = participants
    }
}

// Function to go through all expenses and update users' balances
func allocateExpenses(expenses: [Expense]) {
    
    // Go through each expense in the list and for each person apart of the expense to reallocate money accordingly
    for expense in expenses {
        let splitAmount = expense.amount / Float(expense.participants.count)
        
        //Iterating through each peson apart of the curr expense
        for participant in expense.participants {
            if participant === expense.payer {
                participant.balance += (expense.amount - splitAmount)
            } else {
                participant.balance -= splitAmount
            }
        }
    }
}


//Just an example of how this code should work
let luka = User(name: "Luka", balance: 0.0)
let bob = User(name: "Bob", balance: 0.0)
let charlie = User(name: "Charlie", balance: 0.0)

let expense = Expense(amount: 40.0, payer: luka, participants: [luka, bob, charlie])

allocateExpenses(expenses: [expense])

print("\(luka.name) balance: \(luka.balance)")
print("\(bob.name) balance: \(bob.balance)")
print("\(charlie.name) balance: \(charlie.balance)")

