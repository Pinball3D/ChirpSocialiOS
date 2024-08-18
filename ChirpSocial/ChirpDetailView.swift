//
//  ChirpDetailView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

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
                        }
                        Text("@"+chirp.username)
                    }
                    Spacer()
                }
                HStack {
                    Text(try! AttributedString(markdown: chirp.chirp.replacingOccurrences(of: "<br />", with: "\\n")))
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
    ChirpDetailView(chirp: Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people<br />hi", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://pbs.twimg.com/profile_images/1823159537722966017/K2kTp1hC.jpg", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
}
