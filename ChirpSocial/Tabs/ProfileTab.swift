//
//  ProfileTab.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject var accountManager: AccountManager
    var body: some View {
        NavigationStack {
            if !accountManager.signedIn {
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.crop.circle.badge.exclamationmark").resizable().aspectRatio(contentMode: .fit).frame(height: 50).padding()
                        Text("You are not signed in").font(.custom("Jost", size: 20))
                        Text("Sign in to view your profile").font(.custom("Jost", size: 17)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Spacer()
                }
            } else {
                ProfileView(username: accountManager.profile!.username, profile: accountManager.profile!)
            }
        }
    }
}

#Preview {
    ProfileTab()
}
