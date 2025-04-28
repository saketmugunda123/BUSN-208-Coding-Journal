import SwiftUI
import Firebase
import FirebaseFirestore

struct ClientDashboardView: View {
  let uid: String

  // Client fields
  @State private var name = ""
  @State private var location = ""
  @State private var preferredLanguages = ""
  @State private var legalIssueCategory = ""
  @State private var specificConcern = ""
  @State private var legalIssueDescription = ""
  @State private var urgency = ""
  @State private var preferredContactMethod = ""
  @State private var availability = Date()
  @State private var timeZone = TimeZone.current.identifier
  @State private var isNewMatter = true
  @State private var hasWorkedWithLawyer = false
  @State private var budgetRange = ""
  @State private var annualIncome = ""
  @State private var paymentPreference = ""
  @State private var isLegalAidEligible = false
  @State private var legalAidInfo = ""
  @State private var personalBio = ""

  @State private var message = ""
  @State private var isLoading = true
  @State private var isEditing = false

  // Picker options
  let urgencyOptions = ["Need help ASAP", "Need help within a week", "Need help within a month", "Need help within 3 months", "No specific timeline"]
  let contactOptions = ["Phone", "Email", "In-app chat", "Video call"]
  let budgetOptions = ["<$500", "$500-$2000", "$2000-$5000", "$5000+", "Open-ended"]
  let incomeOptions = ["< $5,000", "$5,000-$15,000", "$15,000-$25,000", "$25,000-$35,000", "$35,000-$45,000", "$45,000-$55,000", "$55,000-$75,000", "> $75,000"]
  let paymentOptions = ["Hourly", "Flat fee", "Contingency", "Unsure"]

  var body: some View {
    VStack(spacing: 20) {
      if isLoading {
        ProgressView()
          .scaleEffect(1.5)
      } else {
        // Summary
        VStack(alignment: .leading, spacing: 8) {
          Text("Name: \(name)")
          Text("Location: \(location)")
          Text("Languages: \(preferredLanguages)")
          Text("Category: \(legalIssueCategory)")
          Text("Concern: \(specificConcern)")
        }
        .padding()

        Button("Edit Profile") {
          isEditing = true
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)

          NavigationLink("Find Lawyers",
              destination: FindLawyersView(clientId: uid)
          )
          NavigationLink("View Appointments",
                         destination: AppointmentListView(clientId: uid))
            .padding(.top, 8)

          .padding(.top)
      }

      if !message.isEmpty {
        Text(message)
          .foregroundColor(.green)
          .padding(.top)
      }

      Spacer()
    }
    .navigationTitle("Client Dashboard")
    .onAppear(perform: loadProfile)
    .sheet(isPresented: $isEditing) {
      NavigationStack {
        Form {
          Section("Basic Info") {
            TextField("Full Name", text: $name)
            TextField("Location", text: $location)
            TextField("Languages", text: $preferredLanguages)
            TextField("Category", text: $legalIssueCategory)
            TextField("Concern", text: $specificConcern)
          }
          Section("Details") {
            TextEditor(text: $legalIssueDescription)
              .frame(height: 100)
            Picker("Urgency", selection: $urgency) {
              ForEach(urgencyOptions, id: \.self) { Text($0) }
            }
            Picker("Contact Method", selection: $preferredContactMethod) {
              ForEach(contactOptions, id: \.self) { Text($0) }
            }
            DatePicker("Availability", selection: $availability, displayedComponents: [.date, .hourAndMinute])
            Toggle("New Matter?", isOn: $isNewMatter)
            Toggle("Worked with Lawyer?", isOn: $hasWorkedWithLawyer)
          }
          Section("Finance") {
            Picker("Budget", selection: $budgetRange) {
              ForEach(budgetOptions, id: \.self) { Text($0) }
            }
            Picker("Income", selection: $annualIncome) {
              ForEach(incomeOptions, id: \.self) { Text($0) }
            }
            Picker("Payment Pref", selection: $paymentPreference) {
              ForEach(paymentOptions, id: \.self) { Text($0) }
            }
            Toggle("Legal Aid Eligible?", isOn: $isLegalAidEligible)
            if isLegalAidEligible {
              TextField("Legal Aid Info", text: $legalAidInfo)
            }
          }
          Section("Bio") {
            TextEditor(text: $personalBio)
              .frame(height: 100)
          }
        }
        .navigationTitle("Edit Profile")
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { isEditing = false }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
              saveProfile()
              isEditing = false
            }
          }
        }
      }
    }
  }

  private func loadProfile() {
    Firestore.firestore()
      .collection("clients")
      .document(uid)
      .getDocument { snap, _ in
        guard let data = snap?.data() else {
          isLoading = false
          return
        }
        name = data["name"] as? String ?? ""
        location = data["location"] as? String ?? ""
        preferredLanguages = data["preferredLanguages"] as? String ?? ""
        legalIssueCategory = data["legalIssueCategory"] as? String ?? ""
        specificConcern = data["specificConcern"] as? String ?? ""
        legalIssueDescription = data["legalIssueDescription"] as? String ?? ""
        urgency = data["urgency"] as? String ?? ""
        preferredContactMethod = data["preferredContactMethod"] as? String ?? ""
        if let ts = data["availability"] as? Timestamp {
          availability = ts.dateValue()
        }
        timeZone = data["timeZone"] as? String ?? TimeZone.current.identifier
        isNewMatter = data["isNewMatter"] as? Bool ?? true
        hasWorkedWithLawyer = data["hasWorkedWithLawyer"] as? Bool ?? false
        budgetRange = data["budgetRange"] as? String ?? ""
        annualIncome = data["annualIncome"] as? String ?? ""
        paymentPreference = data["paymentPreference"] as? String ?? ""
        isLegalAidEligible = data["isLegalAidEligible"] as? Bool ?? false
        legalAidInfo = data["legalAidInfo"] as? String ?? ""
        personalBio = data["personalBio"] as? String ?? ""
        isLoading = false
      }
  }

  private func saveProfile() {
    let data: [String: Any] = [
      "name": name,
      "location": location,
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
      "personalBio": personalBio
    ]
    Firestore.firestore()
      .collection("clients")
      .document(uid)
      .updateData(data) { err in
        message = err == nil ? "Profile updated!" : "Error: \(err!.localizedDescription)"
      }
  }
}

// MARK: Find Lawyers

struct FindLawyersView: View {
  let clientId: String

  @State private var lawyers: [Lawyer] = []
  @State private var isLoading = true
  @State private var errorMessage = ""

  @State private var showScheduler = false
  @State private var selectedLawyer: Lawyer?
  @State private var apptDate = Date()

  var body: some View {
    Group {
      if isLoading { ProgressView() }
      else if !errorMessage.isEmpty {
        Text(errorMessage).foregroundColor(.red)
      } else {
        List(lawyers) { lawyer in
          HStack {
            VStack(alignment: .leading) {
              Text(lawyer.name).font(.headline)
              Text(lawyer.lawFirmName).font(.subheadline)
              Text(lawyer.location).font(.subheadline)
            }
            Spacer()
            Button("Schedule") {
              selectedLawyer = lawyer
              apptDate = max(Date(), lawyer.nextAvailableDate)
              showScheduler = true
            }
            .buttonStyle(.bordered)
          }
        }
      }
    }
    .navigationTitle("Lawyers")
    .onAppear(perform: fetchLawyers)
    .sheet(isPresented: $showScheduler) {
      NavigationStack {
        Form {
          DatePicker("When?", selection: $apptDate,
                     in: Date()...,
                     displayedComponents: [.date, .hourAndMinute])
        }
        .navigationTitle("With \(selectedLawyer?.name ?? "")")
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { showScheduler = false }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Confirm") {
              schedule()
              showScheduler = false
            }
          }
        }
      }
    }
  }

  private func fetchLawyers() {
    Firestore.firestore()
      .collection("lawyers")
      .getDocuments { snap, err in
        isLoading = false
        if let e = err {
          errorMessage = e.localizedDescription
        } else {
          lawyers = snap?.documents.compactMap {
            Lawyer(dict: $0.data())
          } ?? []
        }
      }
  }

  private func schedule() {
    guard let lawyer = selectedLawyer else { return }
    let appt = Appointment(
      clientId: clientId,
      lawyerId: lawyer.id,
      lawyerName: lawyer.name,
      date: apptDate
    )
    Firestore.firestore()
      .collection("appointments")
      .document(appt.id)
      .setData(appt.asDict) { err in
        if let e = err {
          errorMessage = "❌ \(e.localizedDescription)"
        } else {
          errorMessage = "✅ Appointment pending approval"
        }
      }
  }
}


