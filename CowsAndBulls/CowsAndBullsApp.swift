//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by H Hugo Falkman on 04/06/2024.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        
        Settings(content: SettingsView.init)
    }
}
