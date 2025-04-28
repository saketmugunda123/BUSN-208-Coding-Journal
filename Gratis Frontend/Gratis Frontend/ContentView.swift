import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth


struct ContentView: View {
    @State private var isLoginMode = true
    @State private var selectedUserType = "Clients" // "Clients" or "Lawyers"
    
    // Common fields //hello Michelle git
    @State private var email = ""
    @State private var password = ""
    
    @State private var navigateToDashboard = false
    @State private var currentUID = ""
    @State private var loggedInUserType: String? = nil
    
    // Client-specific fields
    @State private var clientName = ""
    @State private var clientLocation = ""
    @State private var preferredLanguages = ""
    @State private var legalIssueCategory = ""
    @State private var specificConcern = ""
    @State private var legalIssueDescription = ""
    @State private var urgency = "Need help within a month" // Default value
    @State private var preferredContactMethod = "Email" // Default value
    @State private var availability = Date()
    @State private var timeZone = TimeZone.current.identifier
    @State private var isNewMatter = true
    @State private var hasWorkedWithLawyer = false
    @State private var budgetRange = "<$500" // Default value
    @State private var annualIncome = "< $5,000" // Default value
    @State private var paymentPreference = "Hourly" // Default value
    @State private var isLegalAidEligible = false
    @State private var legalAidInfo = ""
    @State private var personalBio = ""
    
    // Lawyer-specific fields
    @State private var lawyerName = ""
    @State private var lawFirmName = ""
    @State private var lawyerLocation = ""
    @State private var languagesSpoken = ""
    @State private var barLicenseInfo = ""
    @State private var yearsOfExperience = ""
    @State private var education = ""
    @State private var certifications = ""
    @State private var practiceAreas = ""
    @State private var specializations = ""
    @State private var preferredContactMethods = ""
    @State private var nextAvailableDate = Date()
    @State private var experienceAndAchievements = ""
    @State private var workHistory = ""
    
    // Dropdown options
    let urgencyOptions = ["Need help ASAP", "Need help within a week", "Need help within a month", "Need help within 3 months", "No specific timeline"]
    let contactMethodOptions = ["Phone", "Email", "In-app chat", "Video call"]
    let budgetRangeOptions = ["<$500", "$500-$2000", "$2000-$5000", "$5000+", "Open-ended"]
    let paymentPreferenceOptions = ["Hourly", "Flat fee", "Contingency", "Unsure"]
    let annualIncomeOptions = ["< $5,000", "$5,000-$15,000", "$15,000-$25,000", "$25,000-$35,000", "$35,000-$45,000", "$45,000-$55,000", "$55,000-$75,000", "> $75,000"]
    
    @State private var message = ""
    
    var body: some View {
        NavigationStack {
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
                            Text("Clients").tag("Clients")
                            Text("Lawyers").tag("Lawyers")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    
                    // Common fields
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                    }
                    
                    // Additional fields for sign up only
                    if !isLoginMode {
                        if selectedUserType == "Clients" {
                            Group {
                                TextField("Full Name", text: $clientName)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Location (City, State)", text: $clientLocation)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Preferred Language(s)", text: $preferredLanguages)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Legal Issue Category", text: $legalIssueCategory)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Specific Concern / Subcategory", text: $specificConcern)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextEditor(text: $legalIssueDescription)
                                    .frame(height: 100)
                                    .padding(4)
                                    .background(Color(.secondarySystemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2))
                                    )
                                    .padding()
                                
                                HStack {
                                    Text("When do you need help?")
                                    Spacer()
                                    Picker("", selection: $urgency) {
                                        ForEach(urgencyOptions, id: \.self) { option in
                                            Text(option).tag(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                
                                HStack {
                                    Text("What is your preferred method of contact?")
                                    Spacer()
                                    Picker("", selection: $preferredContactMethod) {
                                        ForEach(contactMethodOptions, id: \.self) { option in
                                            Text(option).tag(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                
                                Picker("New Legal Matter or Ongoing?", selection: $isNewMatter) {
                                    Text("New Matter").tag(true)
                                    Text("Ongoing Matter").tag(false)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                
                                Toggle("Have You Worked with a Lawyer Before?", isOn: $hasWorkedWithLawyer)
                                    .padding()
                                
                                HStack {
                                    Text("What is your budget range?")
                                    Spacer()
                                    Picker("", selection: $budgetRange) {
                                        ForEach(budgetRangeOptions, id: \.self) { option in
                                            Text(option).tag(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                
                                HStack {
                                    Text("What is your annual income?")
                                    Spacer()
                                    Picker("", selection: $annualIncome) {
                                        ForEach(annualIncomeOptions, id: \.self) { option in
                                            Text(option).tag(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                
                                Picker("Payment Preferences", selection: $paymentPreference) {
                                    ForEach(paymentPreferenceOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                
                                VStack(alignment: .leading) {
                                    Toggle("Insurance / Legal Aid Eligible?", isOn: $isLegalAidEligible)
                                        .padding(.bottom, 8)
                                    
                                    if isLegalAidEligible {
                                        TextField("Please enter your insurance provider or legal aid information", text: $legalAidInfo)
                                            .padding()
                                            .background(Color(.secondarySystemBackground))
                                    }
                                }
                                .padding()
                                
                                TextEditor(text: $personalBio)
                                    .frame(height: 100)
                                    .padding(4)
                                    .background(Color(.secondarySystemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2))
                                    )
                                    .padding()
                            }
                        } else {
                            Group {
                                TextField("Full Name", text: $lawyerName)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Law Firm / Practice Name", text: $lawFirmName)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Location (City, State)", text: $lawyerLocation)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Languages Spoken", text: $languagesSpoken)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Bar License Information (State, License Number, Status)", text: $barLicenseInfo)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Years of Experience", text: $yearsOfExperience)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Education (Law School, Graduation Year, Other Degrees)", text: $education)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Certifications", text: $certifications)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Practice Areas", text: $practiceAreas)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Specializations / Subcategories", text: $specializations)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Preferred Contact Methods", text: $preferredContactMethods)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                DatePicker("Next Available Date", selection: $nextAvailableDate, displayedComponents: [.date])
                                    .padding()
                                
                                TextField("Experience & Achievements", text: $experienceAndAchievements)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                
                                TextField("Work History", text: $workHistory)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                            }
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
                    
                    .navigationTitle(isLoginMode ? "Login" : "Sign Up")
                    .navigationDestination(isPresented: $navigateToDashboard) {
                        if loggedInUserType == "Clients" {
                            ClientDashboardView(uid: currentUID)
                        } else if loggedInUserType == "Lawyers" {
                            LawyerDashboardView(uid: currentUID)
                        } else {
                            Text("Profile not found")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Sign Up")
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
            guard let uid = result?.user.uid else { return }
                        let db = Firestore.firestore()
                        // check clients
                       db.collection("clients").document(uid).getDocument { clientSnap, _ in
                           if clientSnap?.exists == true {
                               currentUID = uid
                                loggedInUserType = "Clients"
                                navigateToDashboard = true
                           } else {
                                // check lawyers
                               db.collection("lawyers").document(uid).getDocument { lawyerSnap, _ in
                                    if lawyerSnap?.exists == true {
                                        currentUID = uid
                                        loggedInUserType = "Lawyers"
                                        navigateToDashboard = true
                                    } else {
                                        message = "No profile found for this account."
                                        try? Auth.auth().signOut()
                                    }
                                }
                            }
                        }
        }
    }
    
    func signupUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "Sign Up failed: \(error.localizedDescription)"
                return
            }
            guard let uid = result?.user.uid else { return }
            
            if selectedUserType == "Clients" {
                let data: [String: Any] = [
                    "name": clientName,
                    "location": clientLocation,
                    "preferredLanguages": preferredLanguages,
                    "legalIssueCategory": legalIssueCategory,
                    "specificConcern": specificConcern,
                    "legalIssueDescription": legalIssueDescription,
                    "urgency": urgency,
                    "preferredContactMethod": preferredContactMethod,
                    "availability": Timestamp(date: availability),
                    "timeZone": timeZone,
                    "isNewMatter": isNewMatter,
                    "hasWorkedWithLawyer": hasWorkedWithLawyer,
                    "budgetRange": budgetRange,
                    "annualIncome": annualIncome,
                    "paymentPreference": paymentPreference,
                    "isLegalAidEligible": isLegalAidEligible,
                    "legalAidInfo": legalAidInfo,
                    "personalBio": personalBio,
                    "email": email,
                    "uid": uid
                ]
                Firestore.firestore().collection("clients").document(uid).setData(data) { err in
                    if let err = err {
                        message = "Error saving Client: \(err.localizedDescription)"
                    } else {
                        message = "Signed up successfully as Client"
                    }
                }
            } else {
                let data: [String: Any] = [
                    "name": lawyerName,
                    "lawFirmName": lawFirmName,
                    "location": lawyerLocation,
                    "languagesSpoken": languagesSpoken,
                    "barLicenseInfo": barLicenseInfo,
                    "yearsOfExperience": yearsOfExperience,
                    "education": education,
                    "certifications": certifications,
                    "practiceAreas": practiceAreas,
                    "specializations": specializations,
                    "preferredContactMethods": preferredContactMethods,
                    "nextAvailableDate": Timestamp(date: nextAvailableDate),
                    "experienceAndAchievements": experienceAndAchievements,
                    "workHistory": workHistory,
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
