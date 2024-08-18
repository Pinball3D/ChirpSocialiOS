//
//  SettingsView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/17/24.
//

import SwiftUI

struct SettingsView: View {
    var chirpAPI = ChirpAPI()
    @State var username = ""
    @State var password = ""
    @State var tab: Int = 0
    @State var isSignedIn: Bool = false
    var body: some View {
        VStack {
            Image("Chirpie")
            if isSignedIn {
                Text("You're currently signed in as: \(username)")
            } else {
                Picker("", selection: $tab) {
                    Text("Sign In").tag(0)
                    Text("Sign Up").tag(1)
                }.pickerStyle(.segmented)
                if tab == 0 {
                    VStack {
                        Text("You're currently using a guest account").font(.headline).multilineTextAlignment(.center)
                        Text("You can't interact with chirps or post any of your own. You can't follow accounts either. \n\nIf you have an account, you can sign in here:").font(.subheadline).multilineTextAlignment(.center)
                        TextField("Username", text: $username)
                            .padding(.top)
                            .textFieldStyle(.roundedBorder)
                        SecureField("Password", text: $password)
                            .padding(.bottom)
                            .textFieldStyle(.roundedBorder)
                        Button(action: {
                            chirpAPI.signIn(username: username, password: password) { success, message in
                                if (success) {
                                    self.username = ""
                                    self.password = ""
                                    self.isSignedIn = true
                                } else {
                                    Utility().errorAlert(message!)
                                    self.isSignedIn = false
                                }
                            }
                        }) {
                            Text("Sign In")
                        }
                    }
                } else {
                    Text("Do this on the web for now.")
                }
            }
        }
        Spacer()
        Text("for now this is a really simple page to sign in and out. it might get redone later").multilineTextAlignment(.center)
        Spacer()
    }
}

#Preview {
    SettingsView()
}
