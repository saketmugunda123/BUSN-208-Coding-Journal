//
//  Gratis_FrontendApp.swift
//  Gratis Frontend
//
//  Created by Mugunda, Saket on 4/3/25.
//

import SwiftUI
import Firebase
@main
struct Gratis_FrontendApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {	
            ContentView()
        }
    }
}
