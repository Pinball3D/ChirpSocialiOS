//
//  ChirpDetailView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import LinkPreview

struct ChirpDetailView: View {
    @State var errorMessage = ""
    @State var loading = true
    @State var replies: [Chirp] = []
    @State var reply = ""
    var chirp: Chirp
    var chirpAPI: ChirpAPI = ChirpAPI()
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink {
                    ProfileView(username: chirp.username)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: chirp.profilePic), content: { image in
                            image.resizable().clipShape(Circle()).frame(width: 50, height: 50)//.padding(-20)
                        }, placeholder: {
                            Image("user").resizable().frame(width: 50, height: 50)//.padding(-20)
                        })
                        VStack(alignment: .leading) {
                            HStack {
                                Text(chirp.name)
                                if chirp.isVerified {
                                    Image("verified").resizable().frame(width: 15, height: 15)
                                }
                            }.foregroundStyle(.foreground)
                            Text("@"+chirp.username)
                        }
                        Spacer()
                    }
                }
                HStack {
                    Utility().content(chirp.chirp)
                    Spacer()
                }.padding(.vertical, 10)
                Divider()
                InteractionBar(expanded: true, chirp: chirp).padding(.vertical, 10)
                HStack {
                    TextField(text: $reply, prompt: Text("Reply to @"+chirp.username+"...")) {
                        EmptyView()
                    }
                    Button {
                        chirpAPI.chirp(content: reply, parent: chirp.id)
                        reply = ""
                        chirpAPI.get(.replies, offset: 0, chirpId: chirp.id) { response, success, errorMessage in
                            if success {
                                replies = response
                                loading = false
                            } else { self.errorMessage = errorMessage!; loading = false }
                        }
                    } label: {
                        Text("Reply")//.font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
                    .padding()
                }
                Divider()
                if loading {
                    ProgressView()
                } else if errorMessage != "" {
                    Text(errorMessage).multilineTextAlignment(.center)
                } else {
                    ForEach(replies) {reply in
                        ChirpPreviewView(chirp: reply)
                    }
                }
                Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding(.horizontal)
        }.onAppear() {
            chirpAPI.get(.replies, offset: 0, chirpId: chirp.id) { response, success, errorMessage in
                if success {
                    replies = response
                    loading = false
                } else { self.errorMessage = errorMessage!; loading = false }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChirpDetailView(chirp: Chirp(id: 5326, user: 166, type: "post", chirp: "This is a test @chirp https://pbs.twimg.com/media/GVWrpjAWAAAQu1G?format=jpg&amp;name=medium look at this cool git link https://github.com/NuPlay/LinkPreview", parent: nil, timestamp: 1723679455, via: nil, username: "chirp", name: "Chirp", profilePic: "https://pbs.twimg.com/profile_images/1798508305687441408/5gv4drcK_400x400.jpg", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
    }
}

struct Mention {
    var text: String
    var after: Int
}
