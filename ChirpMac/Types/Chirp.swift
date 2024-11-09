//
//  Chirp.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/7/24.
//

import Foundation

struct Chirp: Identifiable, Decodable, Encodable, Equatable {
    static let _default: Chirp = Chirp(id: 0, user: 0, type: "post", chirp: "Lorem Ipsum", parent: nil, timestamp: Int(Date().timeIntervalSince1970), via: nil, username: "lorem", name: "ipsum", profilePic: "https://example.com/favicon.ico", isVerified: false, likeCount: 0, rechirpCount: 0, replyCount: 0, likedByCurrentUser: false, rechirpedByCurrentUser: false)
    
    let id: Int
    let user: Int
    let type: String
    let chirp: String
    let parent: Int?
    let timestamp: Int
    let via: String?
    let username: String
    let name: String
    let profilePic: String
    let isVerified: Bool
    var likeCount: Int
    var rechirpCount: Int
    var replyCount: Int
    var likedByCurrentUser: Bool
    var rechirpedByCurrentUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case type
        case chirp
        case parent
        case timestamp
        case via
        case username
        case name
        case profilePic
        case isVerified
        case likeCount = "like_count"
        case rechirpCount = "rechirp_count"
        case replyCount = "reply_count"
        case likedByCurrentUser = "liked_by_current_user"
        case rechirpedByCurrentUser = "rechirped_by_current_user"
    }
}
