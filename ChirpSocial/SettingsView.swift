//
//  SettingsView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/17/24.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    var chirpAPI = ChirpAPI()
    @State var username = ""
    @State var password = ""
    @State var tab: Int = 0
    @State var isSignedIn: Bool = (UserDefaults.standard.string(forKey: "PHPSESSID") != "")
    @State var isProccessing: Bool = false
    @State var showAlert = false
    @State var alertMessage: String = ""
    @State var signInOut: Bool = false
    var body: some View {
        List {
            Section {
                HStack {
                    Image("user").resizable().frame(width: 75, height: 75).clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("Account").font(.title2).bold()
                        //replace with button
                        Button {
                            if isSignedIn {
                                UserDefaults.standard.set("", forKey: "PHPSESSID")
                            } else {
                                signInOut.toggle()
                            }
                        } label: {
                            if isSignedIn {
                                Text("Sign Out")
                            } else {
                                Text("Sign In")
                            }
                        }

                    }
                }
            }
            Section {
                Text(UserDefaults.standard.string(forKey: "APNStoken") ?? "notifs not enabled")
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = UserDefaults.standard.string(forKey: "APNStoken") ?? "notifs not enabled"
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            }
            Section {
                Text("Still nothing to see here...")
            }
            Section {
                Text("Follow Me!")
                Text("Twitter https://x.com/AndrewSmiley20")
                Text("Github https://github.com/Pinball3D")
                Text("Website https://smileyzone.net")
            }
            Section {
                Text("THIS IS AN UNOFFICIAL CHIRP CLIENT. CHIRP IS NOT A PART OF THIS APP. ANY ISSUE SHOULD BE REPORTED TO andrew@smileyzone.net NOT CHIRP")
            }
        }.popover(isPresented: $signInOut) {
            VStack {
                VStack {
                    Text("You're currently using a guest account").font(.headline).multilineTextAlignment(.center)
                    Text("You can't interact with chirps or post any of your own. You can't follow accounts either. \n\nIf you have an account, you can sign in here:").font(.subheadline).multilineTextAlignment(.center)
                    TextField("Username", text: $username)
                        .padding(.top)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                        .padding(.bottom)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        isProccessing = true
                        chirpAPI.signIn(username: username, password: password) { success, message in
                            if (success) {
                                isProccessing = false
                                self.username = ""
                                self.password = ""
                                self.isSignedIn = true
                                signInOut.toggle()
                            } else {
                                alertMessage = message!
                                showAlert = true
                                isProccessing = false
                                self.isSignedIn = false
                            }
                        }
                    }) {
                        Text("Sign In")
                    }.disabled(isProccessing)
                }
            }
            .padding()
            .alert("Error", isPresented: $showAlert) {
                Button {
                    showAlert = false
                } label: {
                    Text("ok")
                }
            } message: {
                Text(alertMessage)
            }
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
