//
//  ChirpListView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/19/24.
//

import SwiftUI
import SkeletonUI
import Drops

struct ChirpListView: View {
    @State var scrollProxy: ScrollViewProxy? = nil
    @State var chirps: [Chirp]? = nil
    var userId: Int? = nil
    var chirpId: Int? = nil
    var type: ChirpListType
    var displayNow = true
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    if chirps != [] {
                        if chirps != nil {
                            ForEach(chirps!) { chirp in
                                ChirpListElementView(chirp: chirp, skeleton: false).padding()
                                    .background {
                                        if chirps!.count > 2 {
                                            if chirps![chirps!.count-3] == chirp {
                                                LazyVStack {
                                                    Color.clear.onAppear {
                                                        ChirpAPI.shared.get(getType(type), offset: chirps!.count, userId: userId, chirpId: chirpId, callback: { chirps, success, error in
                                                            if success {
                                                                self.chirps! += chirps
                                                            }
                                                        })
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                            }.onAppear { scrollProxy = proxy }
                        } else {
                            ForEach(1..<8) { _ in
                                ChirpListElementView(chirp: ._default, skeleton: true).padding()
                            }
                        }
                    }
                    
                }
            }.onAppear {
                if type != .following {
                    ChirpAPI.shared.get(getType(type), offset: 0, userId: userId, chirpId: chirpId, callback: { response, success, error in
                        if success {
                            print("[CHIRP LIST VIEW] SUCCESS")
                            chirps = response
                        } else {
                            Drops.show(Drop(stringLiteral: error!))
                        }
                    })
                }
            }
        }
    }
    func getType(_ _for: ChirpListType) -> getType {
        switch (_for) {
        case .forYou:  return .chirps
        case .following: return .chirps
        case .replies:  return .replies
        case .userChirps: return .userChirps
        case .userReplies: return .userReplies
        case .userMedia: return .userMedia
        case .userLikes: return .userLikes
        }
    }
}
#Preview {
    ChirpListView(type: .forYou)
}

enum ChirpListType {
    case forYou
    case following
    case replies
    case userChirps
    case userReplies
    case userMedia
    case userLikes
}
