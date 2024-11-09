//
//  NotificationsTab.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct NotificationsTab: View {
    @State var notifications: [ChirpNotification] = []
    @AppStorage("notificationBadgeCount") var notificationBadgeCount = 0
    @State var tab: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                CustomTabView(tab: $tab, tabs: ["All", "Mentions"]).padding(.horizontal)
                if tab == 0 {
                    ScrollView {
                        ForEach(notifications) {notification in
                            NotificationsListItem(notification: notification)
                            Divider()
                        }
                    }.refreshable {
                        if let savedNotifs = UserDefaults(suiteName: "group.chirp")!.object(forKey: "notifications") as? Data {
                            let decoder = JSONDecoder()
                            if let loadedNotifs = try? decoder.decode([ChirpNotification].self, from: savedNotifs) {
                                notifications = loadedNotifs
                                print("[NOTFIS VIEW] test2")
                            }
                            print("[NOTFIS VIEW] test")
                        }
                    }
                } else {
                    Spacer()
                }
            }.navigationTitle("Notifications")
        }.onAppear {
            notificationBadgeCount = 0
            UIApplication.shared.applicationIconBadgeNumber = 0
            UserDefaults(suiteName: "group.chirp")!.set(0, forKey: "badgeCount")
            print("[NOTFIS VIEW] test3")
            if let savedNotifs = UserDefaults(suiteName: "group.chirp")!.object(forKey: "notifications") as? Data {
                let decoder = JSONDecoder()
                if let loadedNotifs = try? decoder.decode([ChirpNotification].self, from: savedNotifs) {
                    notifications = loadedNotifs
                    print("[NOTFIS VIEW] test2")
                }
                print("[NOTFIS VIEW] test")
            }
        }
    }
}

#Preview {
    NotificationsTab()
}

struct NotificationsListItem: View {
    var notification: ChirpNotification
    var body: some View {
        NavigationLink {
            ChirpDetailView(chirp: notification.chirp)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: notification.chirp.profilePic), content: { image in
                        image.resizable().clipShape(Circle()).frame(width: 50, height: 50)//.padding(-20)
                    }, placeholder: {
                        Image("user").resizable().frame(width: 50, height: 50)//.padding(-20)
                    }).overlay {
                        //HStack {
                        //   Spacer().frame(width: 38, height: 38)
                        //   VStack {
                        //       Spacer().frame(width: 38, height: 38)
                        //Image("liked").frame(width: 25, height: 25).padding(3)//.background(Color.secondary).clipShape(Circle())
                        //   }
                        //}
                    }
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text("New Chirp from @\(notification.chirp.username)").font(.custom("Jost", size: 19))
                    ChirpContentView(chirp: notification.chirp)
                }
                Spacer()
            }.padding(.horizontal)
        }.foregroundStyle(.primary)
    }
}
