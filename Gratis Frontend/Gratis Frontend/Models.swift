//
//  Models.swift
//  Gratis Frontend
//
//  Created by Mugunda, Saket on 4/27/25.
//

import Foundation
import FirebaseFirestore

typealias FirestoreDict = [String: Any]

// MARK: - Client model
struct Client: Identifiable {
    var id: String
    var name: String
    var location: String
    var preferredLanguages: String
    var legalIssueCategory: String
    var specificConcern: String
    var legalIssueDescription: String
    var urgency: String
    var preferredContactMethod: String
    var availability: Date
    var timeZone: String
    var isNewMatter: Bool
    var hasWorkedWithLawyer: Bool
    var budgetRange: String
    var annualIncome: String
    var paymentPreference: String
    var isLegalAidEligible: Bool
    var legalAidInfo: String
    var personalBio: String
    var email: String

    init?(dict: FirestoreDict) {
        guard
            let uid = dict["uid"] as? String,
            let name = dict["name"] as? String,
            let location = dict["location"] as? String,
            let preferredLanguages = dict["preferredLanguages"] as? String,
            let legalIssueCategory = dict["legalIssueCategory"] as? String,
            let specificConcern = dict["specificConcern"] as? String,
            let legalIssueDescription = dict["legalIssueDescription"] as? String,
            let urgency = dict["urgency"] as? String,
            let preferredContactMethod = dict["preferredContactMethod"] as? String,
            let availabilityTS = dict["availability"] as? Timestamp,
            let timeZone = dict["timeZone"] as? String,
            let isNewMatter = dict["isNewMatter"] as? Bool,
            let hasWorkedWithLawyer = dict["hasWorkedWithLawyer"] as? Bool,
            let budgetRange = dict["budgetRange"] as? String,
            let annualIncome = dict["annualIncome"] as? String,
            let paymentPreference = dict["paymentPreference"] as? String,
            let isLegalAidEligible = dict["isLegalAidEligible"] as? Bool,
            let legalAidInfo = dict["legalAidInfo"] as? String,
            let personalBio = dict["personalBio"] as? String,
            let email = dict["email"] as? String
        else { return nil }

        self.id = uid
        self.name = name
        self.location = location
        self.preferredLanguages = preferredLanguages
        self.legalIssueCategory = legalIssueCategory
        self.specificConcern = specificConcern
        self.legalIssueDescription = legalIssueDescription
        self.urgency = urgency
        self.preferredContactMethod = preferredContactMethod
        self.availability = availabilityTS.dateValue()
        self.timeZone = timeZone
        self.isNewMatter = isNewMatter
        self.hasWorkedWithLawyer = hasWorkedWithLawyer
        self.budgetRange = budgetRange
        self.annualIncome = annualIncome
        self.paymentPreference = paymentPreference
        self.isLegalAidEligible = isLegalAidEligible
        self.legalAidInfo = legalAidInfo
        self.personalBio = personalBio
        self.email = email
    }

    var asDict: FirestoreDict {
        [
            "uid": id,
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
            "personalBio": personalBio,
            "email": email
        ]
    }
}

// MARK: - Lawyer model
struct Lawyer: Identifiable {
    var id: String
    var name: String
    var lawFirmName: String
    var location: String
    var languagesSpoken: String
    var barLicenseInfo: String
    var yearsOfExperience: String
    var education: String
    var certifications: String
    var practiceAreas: String
    var specializations: String
    var preferredContactMethods: String
    var nextAvailableDate: Date
    var experienceAndAchievements: String
    var workHistory: String
    var email: String

    init?(dict: FirestoreDict) {
        guard
            let uid = dict["uid"] as? String,
            let name = dict["name"] as? String,
            let firm = dict["lawFirmName"] as? String,
            let location = dict["location"] as? String,
            let languages = dict["languagesSpoken"] as? String,
            let barInfo = dict["barLicenseInfo"] as? String,
            let years = dict["yearsOfExperience"] as? String,
            let education = dict["education"] as? String,
            let certifications = dict["certifications"] as? String,
            let practiceAreas = dict["practiceAreas"] as? String,
            let specializations = dict["specializations"] as? String,
            let preferredContacts = dict["preferredContactMethods"] as? String,
            let nextDateTS = dict["nextAvailableDate"] as? Timestamp,
            let experience = dict["experienceAndAchievements"] as? String,
            let workHistory = dict["workHistory"] as? String,
            let email = dict["email"] as? String
        else { return nil }

        self.id = uid
        self.name = name
        self.lawFirmName = firm
        self.location = location
        self.languagesSpoken = languages
        self.barLicenseInfo = barInfo
        self.yearsOfExperience = years
        self.education = education
        self.certifications = certifications
        self.practiceAreas = practiceAreas
        self.specializations = specializations
        self.preferredContactMethods = preferredContacts
        self.nextAvailableDate = nextDateTS.dateValue()
        self.experienceAndAchievements = experience
        self.workHistory = workHistory
        self.email = email
    }

    var asDict: FirestoreDict {
        [
            "uid": id,
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
            "workHistory": workHistory,
            "email": email
        ]
    }
}

struct Appointment: Identifiable {
  var id: String
  var clientId: String
  var lawyerId: String
  var lawyerName: String
  var date: Date
  var status: String    // "pending", "approved", "rejected"
  var attended: Bool

  init(
    id: String = UUID().uuidString,
    clientId: String,
    lawyerId: String,
    lawyerName: String,
    date: Date,
    status: String = "pending",
    attended: Bool = false
  ) {
    self.id = id
    self.clientId = clientId
    self.lawyerId = lawyerId
    self.lawyerName = lawyerName
    self.date = date
    self.status = status
    self.attended = attended
  }

  init?(dict: FirestoreDict, documentID: String) {
    guard
      let clientId = dict["clientId"] as? String,
      let lawyerId = dict["lawyerId"] as? String,
      let lawyerName = dict["lawyerName"] as? String,
      let ts = dict["date"] as? Timestamp,
      let status = dict["status"] as? String,
      let attended = dict["attended"] as? Bool
    else { return nil }

    self.id = documentID
    self.clientId = clientId
    self.lawyerId = lawyerId
    self.lawyerName = lawyerName
    self.date = ts.dateValue()
    self.status = status
    self.attended = attended
  }

  var asDict: FirestoreDict {
    [
      "clientId": clientId,
      "lawyerId": lawyerId,
      "lawyerName": lawyerName,
      "date": Timestamp(date: date),
      "status": status,
      "attended": attended
    ]
  }

  var dateFormatted: String {
    let fmt = DateFormatter()
    fmt.dateStyle = .medium; fmt.timeStyle = .short
    return fmt.string(from: date)
  }
}
