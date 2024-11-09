//
//  NavigationController.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/8/24.
//
import Foundation

class NavigationController: ObservableObject {
    @Published var sideBarTab = 0
    @Published var mainFeedTab = 0
    @Published var centerContent: ContentType = .home
}

enum ContentType {
    case home
    case discover
    case profile
    case directMessages
    case notifications
    case chirp(Chirp)
}
