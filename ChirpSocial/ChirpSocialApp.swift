//
//  ChirpSocialApp.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

@main
struct ChirpSocialApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
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
        center.setBadgeCount(0)
        completionHandler([.sound, .badge, .banner])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // Convert device token to string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "APNStoken")
        print("hmmm")
        if ChirpAPI().getSessionToken() != "" {
            print("there is a session ID")
            if UserDefaults.standard.string(forKey: "username") == nil {
                ChirpAPI().sendAPNSTokenToDiscord(token: token, username: "No username, prompting user now....") { success, errorMessage in
                    print("maybe")
                }
                UserDefaults.standard.set(true, forKey: "needUsername")
            } else {
                ChirpAPI().sendAPNSTokenToDiscord(token: token, username: UserDefaults.standard.string(forKey: "username")!) { success, errorMessage in
                    print("maybe")
                }
            }
            
        } else {
            print("no session ID")
            ChirpAPI().sendAPNSTokenToDiscord(token: token, username: "LITERALLY AN UNKNOWN USER") { success, errorMessage in
                print("maybe")
            }
        }
        // Send token to server
    }
}
