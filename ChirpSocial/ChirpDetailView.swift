//
//  ChirpDetailView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import Drops
import Translation
struct ChirpDetailView: View {
    @State var translatedChirp: String? = nil
    var chirp: Chirp
    @State var translate = false
    var chirpTranslated: Chirp {
        if let newText = translatedChirp {
            return Chirp(id: chirp.id, user: chirp.user, type: chirp.type, chirp: newText, parent: chirp.parent, timestamp: chirp.timestamp, via: chirp.via, username: chirp.username, name: chirp.name, profilePic: chirp.profilePic, isVerified: chirp.isVerified, likeCount: chirp.likeCount, rechirpCount: chirp.rechirpCount, replyCount: chirp.replyCount, likedByCurrentUser: chirp.likedByCurrentUser, rechirpedByCurrentUser: chirp.rechirpedByCurrentUser)
        } else {
            return chirp
        }
    }
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.accentColor)
                .frame(maxWidth: .infinity, maxHeight: 2)
            
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        ProfileInfoView(chirp: chirp, user: nil).padding(.horizontal)
                        Spacer()
                        Menu("", systemImage: "ellipsis") {
                            Text("Delete chirp")
                            Text("Edit Chirp")
                            Divider()
                            NavigationLink("Debug") {
                                DebugView(structToInspect: chirp)
                            }
                        }.foregroundStyle(.primary)
                    }
                    ChirpContentView(chirp: chirpTranslated, expanded: true).padding(.vertical, 10).padding(.horizontal)
                    Divider()
                    if #available(iOS 18.0, *) {
                        TranslationButtonView(originalText: chirp.chirp, translatedText: $translatedChirp).padding(.horizontal)
                    }
                    Group {
                        Text("Posted on: ")+Text(formatDate(Date(timeIntervalSince1970: Double(chirp.timestamp))))+Text(", via Chirp for Web")
                    }.foregroundStyle(.secondary).padding(.horizontal).font(themeManager.currentTheme.UIFont.value)
                    InteractionBar(expanded: true, chirp: chirp).padding(.vertical, 10).padding(.horizontal)
                    Divider()
                    ChirpListView(chirpId: chirp.id, type: .replies)
                    Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }.onAppear() {
                print("[Chirp Detail View] onAppear")
                navigationController.currentChirp = chirp
                navigationController.showReplyButton = true
            }.onDisappear() {
                navigationController.currentChirp = nil
                navigationController.showReplyButton = false
            }
            .fullScreenCover(isPresented: $navigationController.replyComposeView) {
                ComposeView(chirpToReply: chirp)
            }
            .overlay {
                if ChirpAPI.shared.getSessionToken() != "" && false {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                navigationController.replyComposeView = true
                            } label: {
                                Text("Reply").font(.headline)
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.black)
                            .padding()
                            .disabled(UserDefaults.standard.string(forKey: "PHPSESSID") == "")
                            
                        }
                    }
                }
            }
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy, hh:mm a"
        return formatter.string(from: date)
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

@available(iOS 18.0, *)
struct TranslationButtonView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var originalText: String
    @Binding var translatedText: String?
    @State var tempTranslation: String? = nil
    @State private var configuration: TranslationSession.Configuration? = nil
    var body: some View {
        VStack {
            Button(translatedText == nil ? "Translate chirp" : "View Original") {
                if tempTranslation != nil {
                    translatedText = tempTranslation
                    tempTranslation = nil
                } else if translatedText == nil {
                    configuration = .init()
                } else {
                    tempTranslation = translatedText
                    translatedText = nil
                }
            }.font(themeManager.currentTheme.UIFont.value)
            .translationTask(configuration) { session in
                do {
                    let result = try await session.translate(originalText)
                    translatedText = result.targetText
                } catch {
                    
                }
            }
        }
    }
}
