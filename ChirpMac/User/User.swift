//
//  Profile.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/24/24.
//

struct User: Identifiable, Codable, Equatable {
    var id: Int
    var name: String
    var username: String
    var bannerPic: String
    var profilePic: String
    var followingCount: Int
    var followersCount: Int
    var joinedDate: String
    var bio: String
    var isCurrentUserFollowing: Bool = false
    var followsCurrentUser: Bool = false
}
