//
//  YtEmbed.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/8/24.
//
import Foundation

struct YtEmbed: Identifiable {
    let id = UUID()
    var originalURL: String
    var title: String
    var description: String
    var photo: String
}
