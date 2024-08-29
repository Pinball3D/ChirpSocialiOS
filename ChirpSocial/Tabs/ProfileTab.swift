//
//  ProfileTab.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct ProfileTab: View {
    var body: some View {
        NavigationStack {
            if UserDefaults.standard.string(forKey: "username") == nil {
                Text("You need to be signed in.")
            } else {
                ProfileView(username: UserDefaults.standard.string(forKey: "username")!)
            }
        }
    }
}

#Preview {
    ProfileTab()
}
