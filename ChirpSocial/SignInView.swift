//
//  SignInView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 9/19/24.
//

import SwiftUI
import Drops

struct SignInView: View {
    @EnvironmentObject var accountManager: AccountManager
    @Binding var signInOut: Bool
    @State var password = ""
    @State var username = ""
    @State var isProcessing = false
    
    var chirpAPI = ChirpAPI()
    var body: some View {
        VStack {
            Image("Icon").resizable().frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 50))
            Text("You're currently using a guest account").font(.headline).multilineTextAlignment(.center)
            Text("You can't interact with chirps or post any of your own. You can't follow accounts either. \n\nIf you have an account, you can sign in here:").font(.subheadline).multilineTextAlignment(.center)
            TextField("Username", text: $username)
                .padding(.top)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                if password != "" && username != "" {
                    isProcessing = true
                    accountManager.signIn(username: username, password: password, callback: {success, message, profile in
                        if (success) {
                            isProcessing = false
                            self.username = ""
                            self.password = ""
                            signInOut.toggle()
                            let drop = Drop(
                                title: "Signed in",
                                icon: UIImage(systemName: "checkmark.circle"),
                                position: .top,
                                duration: 2.0,
                                accessibility: "Alert: Signed in"
                            )
                            Drops.show(drop)
                        } else {
                            isProcessing = false
                            let drop = Drop(
                                title: "There was an error while signing you in. Try again later",
                                icon: UIImage(systemName: "xmark.circle"),
                                position: .top,
                                duration: 2.0,
                                accessibility: "Alert: Error signing you in."
                            )
                            Drops.show(drop)
                        }
                    })
                } else {
                    let drop = Drop(
                        title: "You need to enter your username AND password.",
                        icon: UIImage(systemName: "xmark.circle"),
                        position: .top,
                        duration: 2.0,
                        accessibility: "Alert: You need to enter your username and password."
                    )
                    Drops.show(drop)
                }
            }) {
                Text("Sign In").frame(maxWidth: .infinity)
            }
            .disabled(isProcessing)
            .buttonStyle(.borderedProminent)
            Spacer()
        }.padding()
    }
}

#Preview {
    SignInView(signInOut: .constant(true))
}
