import SwiftUI
import Firebase
import FirebaseFirestore

struct LawyerDashboardView: View {
  let uid: String

  // Profile fields
  @State private var name = ""
  @State private var lawFirmName = ""
  @State private var location = ""
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

  // Appointment state
  @State private var appointments: [Appointment] = []
  @State private var isLoading = true
  @State private var message = ""

  // UI state
  enum Tab { case pending, upcoming, completed }
  @State private var selectedTab: Tab = .pending
  @State private var isEditing = false

  var body: some View {
    VStack(spacing: 16) {
      // Profile section or edit form
      if isEditing {
        editProfileForm
      } else {
        VStack(alignment: .leading, spacing: 4) {
          Text(name).font(.title2).bold()
          Text(lawFirmName).font(.subheadline)
          Text(location).font(.footnote)
        }
        Button("Edit Profile") { isEditing = true }
          .buttonStyle(.borderedProminent)
      }

      Divider()

      // Tab picker
      Picker("", selection: $selectedTab) {
        Text("Pending").tag(Tab.pending)
        Text("Upcoming").tag(Tab.upcoming)
        Text("Completed").tag(Tab.completed)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.horizontal)

      // Appointment list
      if isLoading {
        ProgressView()
      } else {
        List(currentAppointments) { appt in
          HStack {
            VStack(alignment: .leading) {
              Text(appt.dateFormatted)
              Text("Client: \(appt.clientId)").font(.caption)
            }
            Spacer()
            actionButton(for: appt)
          }
        }
      }

      if !message.isEmpty {
        Text(message).foregroundColor(.green)
      }
      Spacer()
    }
    .navigationTitle("Lawyer Dashboard")
    .onAppear(perform: loadAll)
  }

  // MARK: - Profile edit form
  private var editProfileForm: some View {
    NavigationStack {
      Form {
        Section("Basic") {
          TextField("Name", text: $name)
          TextField("Firm", text: $lawFirmName)
          TextField("Location", text: $location)
        }
        Section("Details") {
          TextField("Languages", text: $languagesSpoken)
          TextField("Bar Info", text: $barLicenseInfo)
          TextField("Experience (yrs)", text: $yearsOfExperience)
          TextField("Education", text: $education)
          TextField("Certifications", text: $certifications)
          TextField("Practice Areas", text: $practiceAreas)
          TextField("Specializations", text: $specializations)
          TextField("Contact Methods", text: $preferredContactMethods)
          DatePicker("Next Available", selection: $nextAvailableDate, displayedComponents: [.date])
          TextField("Achievements", text: $experienceAndAchievements)
          TextField("Work History", text: $workHistory)
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

  // MARK: - Computed appointments
  private var currentAppointments: [Appointment] {
    let now = Date()
    switch selectedTab {
    case .pending:
      return appointments.filter { $0.status == "pending" }
    case .upcoming:
      return appointments.filter { $0.status == "approved" && $0.date >= now }
    case .completed:
      return appointments.filter { $0.status == "approved" && $0.date < now }
    }
  }

  // MARK: - Action button
  @ViewBuilder
  private func actionButton(for appt: Appointment) -> some View {
    switch selectedTab {
    case .pending:
      Button("Accept") { updateStatus(appt, to: "approved") }
        .buttonStyle(.bordered)
    case .upcoming:
      Text("Approved").font(.caption).foregroundColor(.green)
    case .completed:
      Text(appt.attended ? "Attended" : "Missed")
        .font(.caption)
        .foregroundColor(appt.attended ? .blue : .red)
    }
  }

  // MARK: - Data loading
  private func loadAll() {
    isLoading = true
    loadProfile()
    Firestore.firestore()
      .collection("appointments")
      .whereField("lawyerId", isEqualTo: uid)
      .getDocuments { snap, _ in
        isLoading = false
        appointments = snap?.documents.compactMap {
          Appointment(dict: $0.data(), documentID: $0.documentID)
        }.sorted { $0.date < $1.date } ?? []
      }
  }

  private func loadProfile() {
    Firestore.firestore()
      .collection("lawyers")
      .document(uid)
      .getDocument { snap, _ in
        guard let data = snap?.data() else { return }
        name = data["name"] as? String ?? ""
        lawFirmName = data["lawFirmName"] as? String ?? ""
        location = data["location"] as? String ?? ""
        languagesSpoken = data["languagesSpoken"] as? String ?? ""
        barLicenseInfo = data["barLicenseInfo"] as? String ?? ""
        yearsOfExperience = data["yearsOfExperience"] as? String ?? ""
        education = data["education"] as? String ?? ""
        certifications = data["certifications"] as? String ?? ""
        practiceAreas = data["practiceAreas"] as? String ?? ""
        specializations = data["specializations"] as? String ?? ""
        preferredContactMethods = data["preferredContactMethods"] as? String ?? ""
        if let ts = data["nextAvailableDate"] as? Timestamp {
          nextAvailableDate = ts.dateValue()
        }
        experienceAndAchievements = data["experienceAndAchievements"] as? String ?? ""
        workHistory = data["workHistory"] as? String ?? ""
      }
  }

  // MARK: - Data saving
  private func saveProfile() {
    let d: [String: Any] = [
      "name": name,
      "lawFirmName": lawFirmName,
      "location": location,
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
      "workHistory": workHistory
    ]
    Firestore.firestore()
      .collection("lawyers")
      .document(uid)
      .updateData(d) { err in
        message = err == nil ? "Profile saved" : err!.localizedDescription
      }
  }

  private func updateStatus(_ appt: Appointment, to status: String) {
    Firestore.firestore()
      .collection("appointments")
      .document(appt.id)
      .updateData(["status": status]) { err in
        if err == nil {
          message = "Status updated"
          loadAll()
        }
      }
  }
}

