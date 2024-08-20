//
//  PostPreviewView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

struct ChirpPreviewView: View {
    var chirpAPI = ChirpAPI()
    var chirp: Chirp
    var body: some View {
            VStack {
                NavigationLink(destination: {
                    ChirpDetailView(chirp: chirp)
                }, label: {
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
                                    Spacer()
                                    TimeAgo(date: Date(timeIntervalSince1970: TimeInterval(chirp.timestamp)))
                                }
                                Text("@"+chirp.username)
                            }
                        }.frame(maxWidth: .infinity)
                        HStack {
                            Utility().content(chirp.chirp)
                            Spacer()
                        }.padding(.vertical, 10)
                    }
                }).foregroundStyle(.primary)
                Divider()
                InteractionBar(chirp: chirp).padding(.top, 10)
            }.padding()
    }
}

#Preview {
    ChirpPreviewView(chirp: Chirp(id: 5371, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "", profilePic: "https://pbs.twimg.com/profile_images/1823159537722966017/K2kTp1hC.jpg", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
}

struct TimeAgo: View {
    var date: Date
    var formatter: RelativeDateTimeFormatter {
        var dtf = RelativeDateTimeFormatter()
        dtf.unitsStyle = .abbreviated
        return dtf
    }
    var body: some View {
        Text(formatter.localizedString(for: date, relativeTo: Date()))
    }
}
