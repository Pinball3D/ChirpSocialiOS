//
//  ProfileView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI
import Drops

struct UserView: View {
//    @EnvironmentObject var themeManager: ThemeManager
    var username: String
    @State var isFollowing: Bool = false
    @State var profile: User? = nil
    @State var tab: Int = 0
    @State var expandedImagePop: Bool = false
    @State var expandedImage: Image?
    @AppStorage("DEVMODE") var devMode: Bool = false
    @State var loadedFromUsername = false
    @State var isValidUser = true
    @Environment(\.presentationMode) var presentationMode
    var inProfileTab = false
    var suspended = false
    var body: some View {
        VStack(spacing: 0) {
            if !inProfileTab {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Chirp").font(.Jost)
                        }
                    }.foregroundStyle(.primary)
                        .padding()
                    Spacer()
                }
            }
            Rectangle()
                .fill(Color.accentColor)
                .frame(maxWidth: .infinity, maxHeight: 2)
            if !isValidUser {
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.crop.circle.badge.exclamationmark").resizable().aspectRatio(contentMode: .fit).frame(height: 50).padding()
                        Text("This account doesn't exist").font(.custom("Jost", size: 20))
                        Text("Try searching for something else").font(.custom("Jost", size: 17)).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Spacer()
                }
            } else if suspended {
                VStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.crop.circle.badge.exclamationmark").resizable().aspectRatio(contentMode: .fit).frame(height: 50).padding()
                        Text("This account is temporarily suspended").font(.custom("Jost", size: 20))
                        HStack(spacing: 0) {
                            Text("Chirp regularly suspends accounts that break ").foregroundStyle(.secondary)
                            Link("our rules", destination: URL(string: "chirp://rules")!)
                        }.font(.custom("Jost", size: 17))
                    }
                    Spacer()
                    Spacer()
                }
            } else if profile == nil {
                ProgressView()
                    .onAppear {
                        ChirpAPI.shared.getUser(username: username) { success, errorMessage, profile in
                            loadedFromUsername = true
                            print("[ProfileView] \(success)")
                            print("[ProfileView] \(errorMessage ?? "")")
                            print("[ProfileView] \(String(describing: profile))")
                            if success {
                                self.profile = profile
                                self.isFollowing = profile?.isCurrentUserFollowing ?? false
                            } else {
                                isValidUser = false
                            }
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
                            image.resizable().clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 5).frame(width: NSScreen.main.bounds.width, height: NSScreen.main.bounds.width/3).onTapGesture {
                                expandedImage = image
                                expandedImagePop = true
                            }
                        } placeholder: {
                            Image("banner").resizable().clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal, 5).frame(width: NSScreen.main.bounds.width, height: NSScreen.main.bounds.width/3)
                        }
                        //Image("banner")
                        Divider().padding(.bottom)
                        HStack {
                            ProfileInfoView(chirp: nil, user: profile!, disableHyperlink: true, inProfile: true)
                            Spacer()
                            if profile != Utility().getUser() {
                                Button(isFollowing ? "Following":"Follow") {
                                    isFollowing.toggle()
                                    ChirpAPI.shared.userInteract(action: isFollowing ? .follow: .unfolllow, user: profile!) {success, error in
                                        if !success {
                                            isFollowing.toggle()
                                            Drops.show("Sign in to interact with users")
                                            
                                        }
                                    }
                                }.buttonStyle(.borderedProminent).foregroundStyle(isFollowing ? .accent : .black).tint(isFollowing ? .gray.opacity(0.5) : .accent).font(.body)
                            }
                            if devMode {
                                NavigationLink {
                                    DebugView(structToInspect: profile!)
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                            }
                            
                        }.padding(.horizontal)
                        HStack {
                            Text(Utility.shared.parseForTwemoji(AttributedString(profile!.bio))).font(.body)
                            Spacer()
                        }.padding(.horizontal)
                        HStack {
                            Text("\(profile!.followingCount) following")
                            Text("\(profile!.followersCount) followers")
                            Text(profile!.joinedDate)
                            Spacer()
                        }.font(.body).foregroundStyle(.secondary).padding(.top).padding(.horizontal)
                        CustomTabView(tab: $tab, tabs: ["Chirps", "Replies", "Media", "Likes"])
                        ZStack {
                            
                        }
                        ChirpListView(userId: profile!.id, type: tab==0 ? .userChirps : (tab==1 ? .userReplies : (tab==2 ? .userMedia : .userLikes)), displayNow: tab == 0)
                        Spacer()
                    }.padding()
                }.onAppear {
                    if !loadedFromUsername {
                        ChirpAPI.shared.getUser(username: profile!.username, callback: { success, error, profile  in
                            if success {
                                self.profile = profile
                                self.isFollowing = profile?.isCurrentUserFollowing ?? false
                            } else {
                                isValidUser = false
                            }
                        })
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    UserView(username: "zero")
}
