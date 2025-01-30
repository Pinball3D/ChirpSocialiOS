//
//  NavigationController.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/8/24.
//

import Foundation
import SwiftUI

class NavigationController: ObservableObject {
    @Published var composeView: Bool = false
    @Published var intButtonType: Int = 1 //0 left, 1 center, 2 right 
    @Published var selectedTab: Int = 0 //0: home 1: discover 2: notifications 3: messages 4: my profile
    @Published var route: [Route] = []
    @Published var imageOverlay: String? = nil
    @Published var refreshing: Bool = false
    @Published var replyComposeView: Bool = false
    @Published var showReplyButton: Bool = false
    @Published var currentChirp: Chirp? = nil
    @Published var reloadAccentColor: Bool = false
    var accentColor: String {
        get {
            UserDefaults.standard.string(forKey: "accentColor") ?? "green"
        }
        set(color) {
            print("[NAV CONTROLLER] \(color)")
            UserDefaults.standard.set(color, forKey: "accentColor")
        }
    }
}


enum Route: Hashable {
    //detail views
    case profile(String)
    case chirp(Int)
    case notification(String)
    case image(String) // async image
    case rules
}

