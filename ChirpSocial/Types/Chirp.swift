//
//  Chirp.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

struct Chirp: Identifiable, Decodable {
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
