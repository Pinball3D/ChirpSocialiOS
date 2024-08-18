//
//  InterationButton.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/16/24.
//

import SwiftUI

struct InterationButton: View {
    @State var currentUserInteracted = false
    var type: InteractionType
    var expanded: Bool = false
    var chirp: Chirp
    var number: Int {
        switch type {
        case .like:
            if chirp.likedByCurrentUser {
                return chirp.likeCount + (currentUserInteracted ? -1 : 0)
            } else {
                return chirp.likeCount + (currentUserInteracted ? 1 : 0)
            }
        case .rechirp:
            if chirp.rechirpedByCurrentUser {
                return chirp.rechirpCount + (currentUserInteracted ? -1 : 0)
            } else {
                return chirp.rechirpCount + (currentUserInteracted ? 1 : 0)
            }
        case .reply:
            return chirp.replyCount
        }
    }
    var interacted: Bool {
        switch type {
        case .like:
            if chirp.likedByCurrentUser {
                return !currentUserInteracted
            } else {
                return currentUserInteracted
            }
        case .rechirp:
            if chirp.rechirpedByCurrentUser {
                return !currentUserInteracted
            } else {
                return currentUserInteracted
            }
        case .reply:
            return false
        }
    }
    var term: String {
        switch type {
        case .like:
            return number == 1 ? "like" : "likes"
        case .rechirp:
            return number == 1 ? "rechirp" : "rechirps"
        case .reply:
            return number == 1 ? "reply" : "replies"
        }
    }
    var image: String {
        switch type {
        case .like:
            return interacted ? "liked" : "like"
        case .rechirp:
            return interacted ? "rechirped" : "rechirp"
        case .reply:
            return "reply"
        }
    }
    var body: some View {
        if type == .reply && !expanded {
            NavigationLink {
                ChirpDetailView(chirp: chirp)
            } label: {
                HStack {
                    Image(image)
                    Text("\(number)")
                }
            }.tint(Color.primary)
        } else {
            Button(action: {
                ChirpAPI().interact(action: type, chirp: chirp) { success, errorMessage in
                    if !success {
                        Utility().errorAlert(errorMessage!)
                        currentUserInteracted = false
                    }
                }
                currentUserInteracted.toggle()
            }) {
                if expanded {
                    VStack {
                        Image(image)
                        Text("\(number) \(term)")
                    }
                } else {
                    HStack {
                        Image(image)
                        Text("\(number)")
                    }
                }
                
            }.tint(Color.primary)
        }
    }
}

#Preview {
    var chirp = Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://pbs.twimg.com/profile_images/1823159537722966017/K2kTp1hC.jpg", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false)
    VStack {
        HStack {
            InterationButton(type: .like, expanded: true, chirp:chirp)
            InterationButton(type: .rechirp, expanded: true, chirp:chirp)
            InterationButton(type: .reply, expanded: true, chirp:chirp)
        }
        HStack {
            InterationButton(type: .like, expanded: false, chirp:chirp)
            InterationButton(type: .rechirp, expanded: false, chirp:chirp)
            InterationButton(type: .reply, expanded: false, chirp:chirp)
        }
    }
}

enum InteractionType: String {
    case like = "like"
    case rechirp = "rechirp"
    case reply = "reply"
}

struct InteractionBar: View {
    @State var expanded: Bool = false
    @State var chirp: Chirp
    
    var body: some View {
        HStack {
            InterationButton(type: .reply, expanded: expanded, chirp: chirp)
            Spacer()
            InterationButton(type: .rechirp, expanded: expanded, chirp: chirp)
            Spacer()
            InterationButton(type: .like, expanded: expanded, chirp: chirp)
        }
    }
}
