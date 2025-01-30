//
//  ChirpSocialApp.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import WhatsNewKit
import Drops

@main
struct ChirpSocialApp: App {
    @StateObject private var accountManager = AccountManager()
    @StateObject private var navigationController = NavigationController()
    @StateObject private var themeManager = ThemeManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Color(themeManager.currentTheme.color))
            .onAppear() {
                WhatsNew.Layout.default.featureListSpacing = 55
                WhatsNew.Layout.default.contentPadding = .init(top: 80, leading: 0, bottom:  0, trailing: 0)
            }
            .environmentObject(navigationController)
            .environmentObject(themeManager)
            .environmentObject(accountManager)
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //center.setBadgeCount(0)
        completionHandler([.sound, .badge, .banner])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // Convert device token to string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "APNStoken")
        print("hmmm")
        ChirpAPI().sendAPNSTokenToDiscord(token: token, username: UserDefaults.standard.string(forKey: "username")) { success, errorMessage in
            print("maybe")
        }
        // Send token to server
    }
}
