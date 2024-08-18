//
//  SignInOutView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct SignInOutView: View {
    @State var tab = 0
    @State var username: String = ""
    @State var password: String = ""
    @State var inviteCode: String = ""
    var chirpAPI: ChirpAPI = ChirpAPI()
    @Binding var popover: Bool
    var body: some View {
        VStack {
            Image("Chirpie")
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
                                self.popover = false
                            } else {
                                Utility().errorAlert(message!)
                            }
                        }
                    }) {
                        Text("Sign In")
                    }
                }
            } else {
                Text("Do this on the web for now.")
            }

            Spacer()
        }.onAppear {
        }
    }
}

#Preview {
    SignInOutView(popover: .constant(true))
}
