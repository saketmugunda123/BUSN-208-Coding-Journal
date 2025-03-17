//
//  TicTacToev1App.swift
//  TicTacToev1
//
//  Created by Rajiv Mukherjee on 2/19/24.
//

import SwiftUI

@main
struct AppEntry: App {
    
    @StateObject var game = GameService() //create an instance of the class
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}
