//
//  ProfileView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct ProfileView: View {
    var chirpAPI = ChirpAPI()
    @State var profile = Profile(profilePic: "", chirps: [], replies: [])
    var body: some View {
        VStack(alignment: .leading) {
            Image("banner").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: UIScreen.main.bounds.width)
            HStack {
                Image("user").resizable().frame(width: 75, height: 75, alignment: .center).clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Divider")
                    Text("@Divider")
                }
                Spacer()
                Button("Follow") {
                    
                }.buttonStyle(.borderedProminent)
            }
            Text("This is a bio where you describe your account using at most 120 characters.")
            HStack {
                Text("0 following")
                Text("0 followers")
                Text("joined Aug 15, 2024")
            }.tint(.gray).padding(.top)
            Spacer()
        }.padding()
            .onAppear {
                //chirpAPI.callback = { _ in
                //    profile = chirpAPI.profile
                //}
                //chirpAPI.getProfileInfo(userID: 170)
            }
    }
}

#Preview {
    ProfileView()
}
