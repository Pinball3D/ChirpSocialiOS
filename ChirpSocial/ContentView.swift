//
//  ContentView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import WhatsNewKit
import Drops

struct ContentView: View {
    @EnvironmentObject var accountManager: AccountManager
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("notificationBadgeCount") var notificationBadgeCount = UIApplication.shared.applicationIconBadgeNumber
    @AppStorage("ver1.8") var isNew = true
    var body: some View {
        TabView(selection: $navigationController.selectedTab) {
            HomeView().tabItem { Image(systemName: "house") }.tag(0)
            DiscoverTab().tabItem { Image(systemName: "magnifyingglass") }.tag(1)
            NotificationsTab().tabItem { Image(systemName: "bell") }.tag(2).badge(notificationBadgeCount)
            MessagesTab().tabItem { Image(systemName: "envelope") }.tag(3)
            ProfileTab().tabItem { Image(systemName: "person") }.tag(4)
        }.onAppear {
            notificationBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            if let user = Utility.shared.getUser() {
                ChirpAPI.shared.getProfile(username: user.username) { success, errorMessage, profile in
                    if success {
                        Utility.shared.setUser(profile!)
                    }
                }
            }
        }.popover(isPresented: $isNew) {
            WhatsNewView(whatsNew: WhatsNew(
                title: .init(text: .init(whatsNewTitle())),
                features: [
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "ladybug"), title: "Bug Fixes", subtitle: "I squashshed bugs so chirpie doesnt get sick."),
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "play.rectangle"), title: "Embeds", subtitle: "I redesigned the UI for embeds and added support for youtube embeds."),
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "paintbrush"), title: "New Themes", subtitle: "Enjoy the new Brat Theme, along with some font based themes!"),
                    WhatsNew.Feature(image: WhatsNew.Feature.Image(systemName: "wand.and.stars"), title: "UI/UX Improvements", subtitle: "I made improvements to the UI/UX of chirp to make your experience better.")],
                secondaryAction: WhatsNew.SecondaryAction(title: "Buy Me a Coffee", action: .openURL(URL(string: "https://buymeacoffee.com/smileyzone"))))).interactiveDismissDisabled(true)
        }
        .overlay(content: {
            if let image = navigationController.imageOverlay {
                ExpandedImageOverlayView(image: image)
            }
        })
        .onOpenURL { url in
            let path = url.absoluteString.replacingOccurrences(of: "chirp://", with: "")
            print(path)
            var components = path.split(separator: "/")
            print(components)
            if components.count > 0 {
                print(components[0])
                switch components[0]{
                case "home":
                    navigationController.selectedTab = 0
                case "discover":
                    navigationController.selectedTab = 1
                case "notifications":
                    navigationController.selectedTab = 2
                case "messages":
                    navigationController.selectedTab = 3
                case "profile":
                    navigationController.selectedTab = 4
                case "compose":
                    navigationController.selectedTab = 0
                    navigationController.composeView = true
                case "chirp":
                    let chirpID = components[1]
                    navigationController.selectedTab = 0
                    navigationController.route.append(Route.chirp(Int(chirpID) ?? -1))
                case "user":
                    let username = components[1]
                    navigationController.selectedTab = 0
                    navigationController.route.append(Route.profile(String(username)))
                case "image":
                    components.removeFirst()
                    let image = components.joined(separator: "/")
                    navigationController.imageOverlay = image
                default:
                    Drops.show("An error occoured.")
                }
            }
        }
    }
    func whatsNewTitle() -> AttributedString {
        var attributedString = AttributedString("What's New in Chirp")
        if let range = attributedString.range(of: "Chirp") {
            attributedString[range].foregroundColor = .accent
        }
        return attributedString
    }
}

#Preview {
    ContentView()
}
