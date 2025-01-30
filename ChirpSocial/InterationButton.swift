//
//  InterationButton.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/16/24.
//

import SwiftUI
import Drops

struct InterationButton: View {
    @EnvironmentObject var accountManager: AccountManager
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
    var interactedColor: Color {
        switch type {
        case .like:
            return Color(red: 0.851, green: 0.176, blue: 0.125)
        case .rechirp:
            return Color(red: 0.071, green: 0.718, blue: 0.416)
        case .reply:
            return .white
        }
    }
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        if type == .reply && !expanded {
            NavigationLink {
                ChirpDetailView(chirp: chirp)
            } label: {
                HStack {
                    Image(image)
                    Text("\(number)").font(themeManager.currentTheme.UIFont.value).foregroundStyle(.gray)
                }
            }
        } else {
            Button(action: {
                if type == .reply {
                    if accountManager.signedIn {
                        navigationController.replyComposeView = true
                        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 1.0)
                    } else {
                        let drop = Drop(stringLiteral: "Sign in to reply to posts")
                        Drops.show(drop)
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                    }
                    
                } else {
                    if accountManager.signedIn {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 1.0)
                        currentUserInteracted.toggle()
                        ChirpAPI().interact(action: type, chirp: chirp) { success, errorMessage in
                            if !success {
                                UINotificationFeedbackGenerator().notificationOccurred(.error)
                                let drop = Drop(stringLiteral: "Sign in to interact with posts")
                                Drops.show(drop)
                                currentUserInteracted = false
                            }
                        }
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        let drop = Drop(stringLiteral: "Sign in to interact with posts")
                        Drops.show(drop)
                    }
                }
            }) {
                if expanded {
                    VStack {
                        Image(image)
                        Text("\(number) \(term)").font(themeManager.currentTheme.UIFont.value).foregroundColor(interacted ? interactedColor : .secondary)
                    }
                } else {
                    HStack {
                        Image(image)
                        Text("\(number)").font(themeManager.currentTheme.UIFont.value).foregroundColor(interacted ? interactedColor : .secondary)
                    }
                }
                
            }
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
    @EnvironmentObject var navigationController: NavigationController
    @State var expanded: Bool = false
    @State var chirp: Chirp
    @AppStorage("DEVMODE") var devMode: Bool = false
    var body: some View {
        HStack {
            if navigationController.intButtonType == 2 {
                if devMode {
                    NavigationLink {
                        DebugView(structToInspect: chirp)
                    } label: {
                        Image(systemName: "ellipsis")
                    }.tint(Color.primary)
                }
                Spacer()
            }
            InterationButton(type: .reply, expanded: expanded, chirp: chirp)
            if navigationController.intButtonType == 1 {
                Spacer()
            }
            InterationButton(type: .rechirp, expanded: expanded, chirp: chirp)
            if navigationController.intButtonType == 1 {
                Spacer()
            }
            InterationButton(type: .like, expanded: expanded, chirp: chirp)
            if navigationController.intButtonType == 0 {
                Spacer()
            }
            if navigationController.intButtonType == 1 || navigationController.intButtonType == 0 {
                if devMode {
                    if navigationController.intButtonType == 1 {
                        Spacer()
                    }
                    NavigationLink {
                        DebugView(structToInspect: chirp)
                    } label: {
                        Image(systemName: "ellipsis")
                    }.tint(Color.primary)
                }
            }
        }
    }
}
