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
  @State private var expandedAppointmentId: String? = nil
  
  var body: some View {
    ZStack {
      Color(UIColor.systemGroupedBackground)
        .ignoresSafeArea()
      
      Group {
        if isLoading {
          VStack {
            ProgressView()
              .scaleEffect(1.5)
            Text("Loading appointments...")
              .foregroundColor(.gray)
              .padding(.top, 8)
          }
        } else if !errorMsg.isEmpty {
          VStack {
            Image(systemName: "exclamationmark.triangle.fill")
              .font(.largeTitle)
              .foregroundColor(.orange)
              .padding(.bottom, 4)
            Text(errorMsg)
              .foregroundColor(.red)
              .multilineTextAlignment(.center)
              .padding()
          }
        } else if appointments.isEmpty {
          VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
              .font(.system(size: 60))
              .foregroundColor(.gray.opacity(0.7))
            Text("No appointments yet")
              .font(.title2)
              .fontWeight(.medium)
            Text("When you schedule appointments with lawyers, they'll appear here.")
              .foregroundColor(.gray)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
          }
        } else {
          ScrollView {
            LazyVStack(spacing: 16) {
              ForEach(appointments) { appt in
                AppointmentCard(appointment: appt,
                               isExpanded: expandedAppointmentId == appt.id)
                  .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                      if expandedAppointmentId == appt.id {
                        expandedAppointmentId = nil
                      } else {
                        expandedAppointmentId = appt.id
                      }
                    }
                  }
              }
            }
            .padding()
          }
        }
      }
    }
    .navigationTitle("Your Appointments")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          fetchAppointments() // Refresh appointments
        } label: {
          Image(systemName: "arrow.clockwise")
        }
      }
    }
    .onAppear(perform: fetchAppointments)
  }

  private func fetchAppointments() {
    isLoading = true
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
}

struct AppointmentCard: View {
  let appointment: Appointment
  let isExpanded: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Card Header
      HStack {
        VStack(alignment: .leading) {
          Text(appointment.lawyerName)
            .font(.headline)
            .foregroundColor(.primary)
          
          Text(appointment.dateFormatted)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        
        Spacer()
        
        // Status badge
        Text(appointment.status.capitalized)
          .font(.caption)
          .fontWeight(.medium)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(statusColor(appointment.status).opacity(0.15))
          .foregroundColor(statusColor(appointment.status))
          .clipShape(Capsule())
      }
      .padding()
      
      // Expandable details section
      if isExpanded {
        Divider()
          .padding(.horizontal)
        
        VStack(alignment: .leading, spacing: 12) {
          DetailRow(icon: "clock.fill", title: "Time", value: formatTime(appointment.date))
          DetailRow(icon: "calendar", title: "Date", value: formatDate(appointment.date))
          DetailRow(icon: "person.fill", title: "Lawyer ID", value: appointment.lawyerId)
          DetailRow(icon: "number", title: "Reference", value: appointment.id)
          
          // Action buttons
          HStack {
            Button {
              // Cancel appointment action
            } label: {
              HStack {
                Image(systemName: "xmark.circle.fill")
                Text("Cancel")
              }
              .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            Button {
              // Contact lawyer action
            } label: {
              HStack {
                Image(systemName: "message.fill")
                Text("Contact")
              }
              .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
          }
        }
        .padding()
        .transition(.move(edge: .top).combined(with: .opacity))
      }
    }
    .background(Color(UIColor.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
  
  private func statusColor(_ status: String) -> Color {
    switch status.lowercased() {
    case "approved": return .green
    case "rejected": return .red
    case "cancelled": return .gray
    default: return .orange
    }
  }
  
  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    return formatter.string(from: date)
  }
}

struct DetailRow: View {
  let icon: String
  let title: String
  let value: String
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(.blue)
        .frame(width: 20)
      
      Text(title)
        .foregroundColor(.secondary)
        .frame(width: 80, alignment: .leading)
      
      Text(value)
        .foregroundColor(.primary)
    }
  }
}
