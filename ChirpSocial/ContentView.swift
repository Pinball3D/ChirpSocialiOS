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
    //@AppStorage("notificationBadgeCount") var notificationBadgeCount = UIApplication.shared.applicationIconBadgeNumber
    @AppStorage("ver1.8") var isNew = true
    var body: some View {
        TabView(selection: $navigationController.selectedTab) {
            VStack(spacing: 0) {
                HomeView()
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 0, y: 0)
                    Spacer()
                }
            }.tabItem {
                Image("house").scaleEffect(0.5)
            }.tag(0)
            VStack(spacing: 0) {
                DiscoverTab()
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 1, y: 0)
                    Spacer()
                }
            }.tabItem {
                Image("search")
            }.tag(1)
            VStack(spacing: 0) {
                NotificationsTab()
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 2, y: 0)
                    Spacer()
                }
            }.tabItem {
                Image("bell")
            }.tag(2)//.badge(notificationBadgeCount)
            VStack(spacing: 0) {
                MessagesTab()
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 3, y: 0)
                    Spacer()
                }
            }.tabItem {
                Image("envelope")
            }.tag(3)
            VStack(spacing: 0) {
                ProfileTab()
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 4, y: 0)
                    Spacer()
                }
            }.tabItem {
                Image("person")
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: 2)
                        .offset(x: (UIScreen.main.bounds.width / 5) * 5, y: 0)
                    Spacer()
                }
            }.tag(4)
        }
        .onAppear {
            //notificationBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            if let user = Utility.shared.getUser() {
                ChirpAPI.shared.getUser(username: user.username) { success, errorMessage, profile in
                    if success {
                        if profile != nil {
                            Utility.shared.setUser(profile!)
                        }
                    }
                }
            }
        }.sheet(isPresented: $isNew) {
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
                case "rules":
                    navigationController.selectedTab = 0
                    navigationController.route.append(.rules)
                default:
                    Drops.show("An error occoured.")
                }
            }
        }
        .onChange(of: navigationController.selectedTab) { newValue in
            UISelectionFeedbackGenerator().selectionChanged()
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
