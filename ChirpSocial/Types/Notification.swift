//
//  Notification.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 9/25/24.
//

import Foundation

struct ChirpNotification: Decodable, Encodable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var chirp: Chirp
    var time: Date = Date()
    //var profile: Profile
    enum type {
        case post
        case reply
        case like
        case follow
        case repost
    }
}
