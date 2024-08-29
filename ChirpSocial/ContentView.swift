//
//  ContentView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    @State var usernameField: String = ""
    @AppStorage("ver1.1") var isNew = true
    @State var tab = 0
    @State var needsUsername = (UserDefaults.standard.string(forKey: "username") == nil && UserDefaults.standard.string(forKey: "PHPSESSID") != nil)
    var body: some View {
        TabView(selection: $tab) {
            HomeView().tabItem {
                Image("house")
            }.tag(0)
            DiscoverTab().tabItem {
                Image("search")
                if (tab == 1) {
                    Color.accentColor
                }
            }.tag(1)
            NotificationsTab().tabItem {
                Image("bell")
            }.tag(2)
            MessagesTab().tabItem {
                Image("envelope")
            }.tag(3)
            ProfileTab().tabItem {
                Image("person")
            }.tag(4)
        }.onAppear {
            UITextView.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "jost"))
            UITabBar.appearance().itemSpacing = 80
            
            //handle moving to new profile account system
            if ChirpAPI().getSessionToken() != "" {
                if UserDefaults.standard.string(forKey: "username") == nil {
                    ChirpAPI().getUsernameFromSessionId(sessionId: ChirpAPI().getSessionToken(), callback: { success, errorMessage, username in
                        if success {
                            UserDefaults.standard.set(username, forKey: "username")
                        }
                    })
                }
            }
        }.popover(isPresented: $isNew) {
            VStack {
                List {
                    Section {
                        HStack {
                            Spacer()
                            Text("!! Please Read !!").font(.title)
                            Spacer()
                        }
                    }
                    Group {
                        Text("The last update I made included push notifications.")
                        Text("Updates for this version include some bug fixes and a new profile page (even though chirp said it wasnt possible). On any expanded chirp, click on the username of the person. it also includes this popup which will show anything you need to know.")
                        Text("DISCLAMER: THIS APP IS UNOFFICIAL. IT IS NOT DEVELOPED OR ENDORSED BY CHIRP IN ANY WAY. ANY BUGS SHOULD BE REPORTED TO @AndrewSmiley20 on X or andrew@smileyzone.net")
                    }
                    Section {
                        HStack  {
                            Spacer()
                            Button("I've read everything.") {
                                isNew.toggle()
                            }.buttonStyle(.borderedProminent).foregroundStyle(.black)
                            Spacer()
                        }
                    }
                }
            }
        }.popover(isPresented: $needsUsername) {
            List {
                Text("Due to additions in the app, you need to enter your CHIRP username to continue.")
                TextField("Username", text: $usernameField)
                Button("Submit") {
                    if usernameField.replacingOccurrences(of: "@", with: "").isEmpty {
                        
                    } else {
                        UserDefaults.standard.set(usernameField.replacingOccurrences(of: "@", with: ""), forKey: "username")
                        needsUsername = false
                    }
                }
            }.interactiveDismissDisabled(true)
        }.interactiveDismissDisabled(true)
    }
}

#Preview {
    ContentView()
}


extension UILabel {
    @objc var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}

extension UITextView {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
