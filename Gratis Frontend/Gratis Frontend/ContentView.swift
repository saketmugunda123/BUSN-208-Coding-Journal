import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    @State private var isLoginMode = true
    @State private var selectedUserType = "People" // "People" or "Lawyers"
    
    // Common fields //hello Michelle git
    @State private var email = ""
    @State private var password = ""
    
    // People-specific fields
    @State private var peopleName = ""
    @State private var incomeBracket = ""
    @State private var location = ""
    @State private var ssn = ""
    @State private var lawOfNeed = "" // comma separated string
    
    // Lawyer-specific fields
    @State private var lawyerName = ""
    @State private var lawType = ""
    @State private var typicalCharge = ""
    @State private var nextAvailableDate = Date()
    @State private var barNumber = ""
    
    @State private var message = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Toggle Login vs. Sign Up
                Picker("Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Only show user type picker on sign up
                if !isLoginMode {
                    Picker("User Type", selection: $selectedUserType) {
                        Text("People").tag("People")
                        Text("Lawyers").tag("Lawyers")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                // Common fields
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                // Additional fields for sign up only
                if !isLoginMode {
                    if selectedUserType == "People" {
                        TextField("Name", text: $peopleName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("Income Bracket", text: $incomeBracket)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("Location", text: $location)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("SSN", text: $ssn)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("Law of Need (comma separated)", text: $lawOfNeed)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                    } else {
                        TextField("Name", text: $lawyerName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("Law Type (Practice Area)", text: $lawType)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        TextField("Typical Charge", text: $typicalCharge)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        DatePicker("Next Available Date", selection: $nextAvailableDate, displayedComponents: [.date])
                            .padding()
                        TextField("Bar Number", text: $barNumber)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                    }
                }
                
                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: handleAction) {
                    Text(isLoginMode ? "Login" : "Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
        }
    }
    
    func handleAction() {
        isLoginMode ? loginUser() : signupUser()
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "Login failed: \(error.localizedDescription)"
                return
            }
            message = "Logged in successfully"
        }
    }
    
    func signupUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "Sign Up failed: \(error.localizedDescription)"
                return
            }
            guard let uid = result?.user.uid else { return }
            
            if selectedUserType == "People" {
                // Convert comma separated lawOfNeed into an array
                let lawOfNeedList = lawOfNeed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                let data: [String: Any] = [
                    "name": peopleName,
                    "incomeBracket": incomeBracket,
                    "email": email,
                    "location": location,
                    "ssn": ssn,
                    "lawOfNeed": lawOfNeedList,
                    "uid": uid
                ]
                Firestore.firestore().collection("people").document(uid).setData(data) { err in
                    if let err = err {
                        message = "Error saving People: \(err.localizedDescription)"
                    } else {
                        message = "Signed up successfully as People"
                    }
                }
            } else {
                let data: [String: Any] = [
                    "name": lawyerName,
                    "lawType": lawType,
                    "typicalCharge": typicalCharge,
                    "nextAvailableDate": Timestamp(date: nextAvailableDate),
                    "barNumber": barNumber,
                    "email": email,
                    "uid": uid
                ]
                Firestore.firestore().collection("lawyers").document(uid).setData(data) { err in
                    if let err = err {
                        message = "Error saving Lawyer: \(err.localizedDescription)"
                    } else {
                        message = "Signed up successfully as Lawyer"
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



