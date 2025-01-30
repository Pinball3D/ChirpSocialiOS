//
//  ChirpMacApp.swift
//  ChirpMac
//
//  Created by Andrew Smiley on 10/30/24.
//

import SwiftUI

@main
struct ChirpMacApp: App {
    @State var needsToRefresh = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(needsToRefresh: $needsToRefresh).accentColor(.accent)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(before: .sidebar) {
                Button("Refresh") {
                    // Refresh
                    needsToRefresh = true
                }
                .keyboardShortcut("R", modifiers: [.command])
            }
        }
        Settings {
            SettingsView()
        }
    }
}
