//
//  NotificationService.swift
//  NotificationContent
//
//  Created by Andrew Smiley on 9/21/24.
//

import UserNotifications
import UIKit
import SwiftSoup

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

            // Check if there's a profile picture URL in the notification
            if let bestAttemptContent = bestAttemptContent {
                    // Deliver the modified notification
                print("[NOTIFICATION SERVICE] test")
                if let json = request.content.userInfo["chirp"] as? [String : Any] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json)
                        if let chirp = try? JSONDecoder().decode(Chirp.self, from: data) {
                            bestAttemptContent.title = "New Chirp from @\(chirp.username)"
                            bestAttemptContent.body = try SwiftSoup.parse(chirp.chirp).text()
                            bestAttemptContent.badge = (UserDefaults(suiteName: "group.chirp")!.integer(forKey: "badgeCount") + 1) as NSNumber
                            //notifications tab
                            UserDefaults(suiteName: "group.chirp")!.set(bestAttemptContent.badge, forKey: "badgeCount")
                            
                           // UserDefaults(suiteName: "group.chirp")!.set([], forKey: "notifications")
                            
                            if let savedNotifs = UserDefaults(suiteName: "group.chirp")!.object(forKey: "notifications") as? Data {
                                let decoder = JSONDecoder()
                                if let loadedNotifs = try? decoder.decode([ChirpNotification].self, from: savedNotifs) {
                                    var notifications: [ChirpNotification] = loadedNotifs
                                    notifications.insert(ChirpNotification(title: bestAttemptContent.title, body: bestAttemptContent.body, chirp: chirp), at: 0)
                                    let encoder = JSONEncoder()
                                    UserDefaults(suiteName: "group.chirp")!.set(try encoder.encode(notifications), forKey: "notifications")
                                }
                            }
                        }
                    } catch {}
                }
                contentHandler(bestAttemptContent)
            } else {
                // No modification needed, deliver the notification as is
                contentHandler(request.content)
            }
        }

        override func serviceExtensionTimeWillExpire() {
            // Called just before the extension will be terminated by the system
            if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
                contentHandler(bestAttemptContent)
            }
        }

}
