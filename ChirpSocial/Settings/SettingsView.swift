//
//  SettingsView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/17/24.
//

import SwiftUI
import UserNotifications
import Drops
import Kingfisher
//import FLEX

struct SettingsView: View {
    @State var intBarType = 0
    @EnvironmentObject var accountManager: AccountManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationController: NavigationController
    @AppStorage("ver1.8") var isNew = false
    //var chirpAPI = ChirpAPI()
    @State var username = ""
    @State var password = ""
    @State var tab: Int = 0
    //@State var isSignedIn: Bool = (UserDefaults.standard.string(forKey: "PHPSESSID") != "")
    @State var isProccessing: Bool = false
    @State var signInOut: Bool = false
    //@State var profile: Profile? = Utility().getUser()
    @AppStorage("DEVMODE") var devMode: Bool = false
    @State var clicks = 0
    //@State var accentColor = UserDefaults.standard.string(forKey: "accentColor") ?? "green"
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 0) {
            NavigationHeader(headerText: "Settings")
            List {
                Section {
                    HStack {
                        if !accountManager.signedIn {
                            Image("user").resizable().frame(width: 50, height: 50).clipShape(Circle())
                        } else {
                            KFImage(URL(string: accountManager.profile!.profilePic)).resizable().frame(width: 50, height: 50).clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(!accountManager.signedIn ? "Account" : "@"+accountManager.profile!.username).font(.title2).bold()
                            //replace with button
                            Button {
                                if accountManager.signedIn {
                                    accountManager.signOut()
                                } else {
                                    signInOut = true
                                }
                            } label: {
                                if accountManager.signedIn {
                                    Text("Sign Out")
                                } else {
                                    Text("Sign In")
                                }
                            }
                            
                        }
                    }
                }
                Section(header: Text("App Settings")) {
                    NavigationLink {
                        ThemesView()
                    } label: {
                        HStack {
                            Text(String(localized: "themes"))
                            Spacer()
                            Text(themeManager.currentTheme.name).foregroundStyle(.secondary)
                        }
                    }
                    Picker(selection: $navigationController.intButtonType) {
                        Text("Left").tag(0)
                        Text("Center").tag(1)
                        Text("Right").tag(2)
                    } label: {
                        Text("Post Buttons Align: ")
                    }
                    
                    
                }
                Section {
                    Link(destination: URL(string: "https://chirp.smileyzone.net")!) {
                        Text("Chirp for iOS")
                    }
                }
                Section {
                    Link(destination: URL(string: "https://buymeacoffee.com/smileyzone")!) {
                        Text("Buy Me A Coffee")
                    }
                    Link(destination: URL(string: "https://x.com/AndrewSmiley20")!) {
                        Text("@AndrewSmiley20 on X")
                    }
                    Link(destination: URL(string: "https://github.com/Pinball3D")!) {
                        Text("Pinball3D on Github")
                    }
                    Link(destination: URL(string: "https://smileyzone.net")!) {
                        Text("My Website")
                    }
                }
                Section(header: Text("DISCLAMER")) {
                    Text("This App is not developed or sanctioned by Chirp. Report any bugs via my socials.").onTapGesture(count: 1) {
                        if !devMode {
                            clicks += 1
                            if clicks == 10 {
                                clicks = 0
                                devMode = true
                                let drop = Drop(stringLiteral: "Developer options enabled")
                                Drops.hideAll()
                                Drops.show(drop)
                            } else if clicks > 6 {
                                let drop = Drop(stringLiteral: String(10-clicks)+" taps left.")
                                Drops.hideAll()
                                Drops.show(drop)
                            }
                        } else {
                            let drop = Drop(stringLiteral: "Developer options already enabled")
                            Drops.show(drop)
                        }
                    }
                }
                if devMode {
                    Section(header: Text("Developer Options")) {
                        Button {
                            navigationController.accentColor = "blue"
                        } label: {
                            Text("make accent red")
                        }
                        
                        Button("Remove phpsessid") {
                            UserDefaults.standard.set(nil, forKey: "PHPSESSID")
                        }
                        Button("Remove username") {
                            UserDefaults.standard.set(nil, forKey: "username")
                        }
                        Button("Turn off dev mode") {
                            devMode = false
                        }
                        Button("turn on new popover") {
                            isNew = true
                        }
                        Button("send notif registration") {
                            ChirpAPI().sendAPNSTokenToDiscord(token: "test", username: "someone", callback: { _,_  in })
                        }
                        Button(UserDefaults.standard.string(forKey: "APNStoken") ?? "notifs not enabled") {
                            UIPasteboard.general.string = UserDefaults.standard.string(forKey: "APNStoken")
                        }
                        Button("FLEX") {
                            Drops.show("dont work no more")
                            //FLEXManager.shared.toggleExplorer()
                        }
                        Button("clear notifs") {
                            let cleared: [ChirpNotification] = []
                            let encoder = JSONEncoder()
                            do {
                                UserDefaults(suiteName: "group.chirp")!.set(try encoder.encode(cleared), forKey: "notifications")
                            } catch {
                                
                            }
                        }
                        Text(Utility.shared.parseForTwemoji("😴😴❤️😒😂"))
                    }
                }
            }
            .font(themeManager.currentTheme.UIFont.value)
            .sheet(isPresented: $signInOut) {
                SignInView(signInOut: $signInOut)
            }
        }.gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
            
        }))
    }
}

#Preview {
    SettingsView()
}
