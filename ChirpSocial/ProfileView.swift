//
//  ProfileView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI

struct ProfileView: View {
    var username: String
    @State var isFollowing: Bool = false
    var chirpAPI = ChirpAPI()
    @State var profile: Profile? = nil
    @State var chirps: [Chirp] = []
    @State var replies: [Chirp] = []
    @State var media: [Chirp] = []
    @State var likes: [Chirp] = []
    @State var tab: Int = 0
    var body: some View {
        if profile == nil {
            ProgressView()
                .onAppear {
                    chirpAPI.getProfile(username: username) { success, errorMessage, profile in
                        print(success)
                        print(errorMessage)
                        print(profile)
                        self.profile = profile
                    }
                    //chirpAPI.callback = { _ in
                    //    profile = chirpAPI.profile
                    //}
                    //chirpAPI.getProfileInfo(userID: 170)
                }
        } else {
            ScrollView {
                VStack(alignment: .center) {
                    AsyncImage(url: URL(string: profile!.bannerPic)) { image in
                        image.resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3).clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3)
                    }
                    //Image("banner")
                    Divider()
                    HStack {
                        AsyncImage(url: URL(string: profile!.profilePic)) { image in
                            image.resizable().frame(width: 50, height: 50, alignment: .center).clipShape(Circle())
                        } placeholder: {
                            ProgressView().frame(width: 75, height: 75, alignment: .center).clipShape(Circle())
                        }
                        //Image("user")
                        VStack(alignment: .leading) {
                            Text(profile!.name)
                            Text(profile!.username)
                        }
                        Spacer()
                        Button(isFollowing ? "Following":"Follow") {
                            isFollowing.toggle()
                        }.buttonStyle(.borderedProminent).foregroundStyle(isFollowing ? .accent : .black).tint(isFollowing ? .gray.opacity(0.5) : .accent)
                    }.padding(.horizontal)
                    HStack {
                        Text(profile!.bio)
                        Spacer()
                    }.padding(.horizontal)
                    HStack {
                        Text("\(profile!.followingCount) following")
                        Text("\(profile!.followersCount) followers")
                        Text(profile!.joinedDate)
                        Spacer()
                    }.tint(.gray).padding(.top).padding(.horizontal)
                    HStack {
                        Picker("", selection: $tab) {
                            Text("Chirps").tag(0)
                            Text("Replies").tag(1)
                            Text("Media").tag(2)
                            Text("Likes").tag(3)
                        }.pickerStyle(.segmented)
                    }.padding(.horizontal)
                    Divider()
                    switch tab {
                    case 0:
                        ForEach(chirps) {reply in
                            ChirpPreviewView(chirp: reply)
                        }
                    case 1:
                        ForEach(replies) {reply in
                            ChirpPreviewView(chirp: reply)
                        }.onAppear() {
                            print("hi")
                        }
                    case 2:
                        ForEach(media) {reply in
                            ChirpPreviewView(chirp: reply)
                        }
                    case 3:
                        ForEach(likes) {reply in
                            ChirpPreviewView(chirp: reply)
                        }
                    default:
                        ForEach(chirps) {reply in
                            ChirpPreviewView(chirp: reply)
                        }
                    }
                    Spacer()
                }.padding().onAppear {
                    chirpAPI.get(.userChirps, offset: chirps.count, userId: profile?.id) { response, success, errorMessage in
                        if success {
                            chirps = response
                        }
                    }
                    chirpAPI.get(.userReplies, offset: replies.count, userId: profile?.id) { response, success, errorMessage in
                        if success {
                            replies = response
                        }
                    }
                    chirpAPI.get(.userMedia, offset: media.count, userId: profile?.id) { response, success, errorMessage in
                        if success {
                            media = response
                        }
                    }
                    chirpAPI.get(.userLikes, offset: likes.count, userId: profile?.id) { response, success, errorMessage in
                        if success {
                            likes = response
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(username: "zero")
}
