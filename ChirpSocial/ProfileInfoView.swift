//
//  ProfileInfoView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 9/20/24.
//

import SwiftUI
import Kingfisher
import SkeletonUI

struct ProfileInfoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let chirp: Chirp?
    let user: User?
    var profilePic: String {
        if chirp == nil { return user!.profilePic } else { return chirp!.profilePic }
    }
    var name: String {
        if chirp == nil { return user!.name } else { return chirp!.name }
    }
    var username: String {
        if chirp == nil { return user!.username } else { return chirp!.username }
    }
    var isVerified: Bool {
        if chirp == nil { return false } else { return chirp!.isVerified}
    }
    var disableHyperlink: Bool = false
    var skeleton: Bool = false
    var inProfile: Bool = false
    @EnvironmentObject var navigationController: NavigationController
    var body: some View {
        if disableHyperlink {
            content
        } else {
            NavigationLink {
                UserView(username: username, profile: user)
            } label: {
                content
            }
        }
    }
    
    var content: some View {
        HStack {
            picView.skeleton(with: skeleton).frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                HStack {
                    if skeleton { nameView.skeleton(with: skeleton).frame(width: 100) } else { nameView }
                    if isVerified && !skeleton {
                        Image("verified").resizable().frame(width: 17, height: 17)
                    }
                }.foregroundStyle(.foreground)
                if skeleton { usernameView.skeleton(with: skeleton).frame(width: 75) } else {
                    HStack {
                        usernameView
                        if inProfile {
                            if user != nil {
                                if user!.followsCurrentUser {
                                    Text("Follows You").font(.custom("Jost", size: 14)).padding(.horizontal, 10).background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }.font(themeManager.currentTheme.UIFont.value)
    }
    var picView: some View {
        VStack {
            if profilePic.isEmpty {
                Image("user").resizable().frame(width: 50, height: 50)
            } else {
                KFImage(URL(string: profilePic)).resizable().clipShape(Circle()).frame(width: 50, height: 50).onTapGesture {
                    navigationController.imageOverlay = profilePic
                }
            }
        }
    }
    var nameView: some View {
        Text(Utility.shared.parseForTwemoji(AttributedString(name)))
    }
    var usernameView: some View {
        VStack {
            if disableHyperlink {
                rawUsernameView.foregroundStyle(Color.secondary)
            } else { rawUsernameView }
        }
    }
    var rawUsernameView: some View {
        Text("@"+username)
    }
}

#Preview {
    ProfileInfoView(chirp: nil, user: nil)
}
