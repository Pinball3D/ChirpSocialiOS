//
//  PostPreviewView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import Kingfisher

struct SChirpPreviewView: View {
    @EnvironmentObject var navigationController: NavigationController
    var chirpAPI = ChirpAPI()
    var chirp: Chirp
    var body: some View {
        VStack {
            NavigationLink(destination: {
                ChirpDetailView(chirp: chirp)
            }, label: {
                VStack {
                    ProfileInfoView(chirp: chirp, user: nil).frame(maxWidth: .infinity)
                    HStack {
                        //Utility().content(chirp.chirp).environmentObject(navigationController)
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
    SChirpPreviewView(chirp: Chirp(id: 5371, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "", profilePic: "https://pbs.twimg.com/profile_images/1823159537722966017/K2kTp1hC.jpg", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
}

struct TimeAgo: View {
    var date: Date
    var formatter: RelativeDateTimeFormatter {
        let dtf = RelativeDateTimeFormatter()
        dtf.unitsStyle = .abbreviated
        return dtf
    }
    var body: some View {
        Text(formatter.localizedString(for: date, relativeTo: Date()))
    }
}
