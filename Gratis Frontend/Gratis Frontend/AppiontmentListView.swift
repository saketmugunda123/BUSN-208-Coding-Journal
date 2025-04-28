//
//  AppiontmentListView.swift
//  Gratis Frontend
//
//  Created by Mugunda, Saket on 4/27/25.
//

import SwiftUI
import FirebaseFirestore

struct AppointmentListView: View {
  let clientId: String

  @State private var appointments: [Appointment] = []
  @State private var isLoading = true
  @State private var errorMsg = ""

  var body: some View {
    Group {
      if isLoading {
        ProgressView()
      } else if !errorMsg.isEmpty {
        Text(errorMsg).foregroundColor(.red)
      } else {
        List(appointments) { appt in
          HStack {
            VStack(alignment: .leading) {
              Text(appt.lawyerName).font(.headline)
              Text(appt.dateFormatted).font(.subheadline)
            }
            Spacer()
            Text(appt.status.capitalized)
              .font(.caption)
              .padding(4)
              .background(statusColor(appt.status).opacity(0.2))
              .cornerRadius(4)
          }
        }
      }
    }
    .navigationTitle("Your Appointments")
    .onAppear(perform: fetchAppointments)
  }

    private func fetchAppointments() {
      let db = Firestore.firestore()
      db.collection("appointments")
        .whereField("clientId", isEqualTo: clientId)
        .getDocuments { snap, err in
          isLoading = false
          if let e = err {
            errorMsg = e.localizedDescription
            return
          }
          // map + client-side sort by date
          var appts = snap?.documents.compactMap {
            Appointment(dict: $0.data(), documentID: $0.documentID)
          } ?? []
          appts.sort { $0.date < $1.date }
          appointments = appts
        }
    }


  private func statusColor(_ status: String) -> Color {
    switch status {
      case "approved": return .green
      case "rejected": return .red
      default:           return .orange
    }
  }
}
