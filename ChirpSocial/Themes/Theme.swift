//
//  Theme.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/28/24.
//
import Foundation
import SwiftUI

struct Theme: Encodable, Decodable, Identifiable, Equatable {
    static var standard = Theme(name: "Chirpie Green", color: "green")
    var id: UUID = UUID()
    let name: String
    let color: String
    var icon: String = "Chirpie"
    var appIcon: String? = nil
    var UIFont: ThemeFont = .Jost
    var PostFont: ThemeFont = .Satoshi
}

enum ThemeFont: String, Codable {
    case Brat
    case Jost
    case Satoshi
    case ComicSans
    case Wingdings
    case Mojangles

    var value: Font {
        switch self {
        case .Brat:
            return .Brat
        case .Jost:
            return .Jost
        case .Satoshi:
            return .Satoshi
        case .ComicSans:
            return .ComicSans
        case .Wingdings:
            return .Wingdings
        case .Mojangles:
            return .Mojangles
        }
    }
}
extension Font {
    static var Brat: Self = .custom("Arial Narrow", size: 17)
    static var ComicSans: Self = .custom("ComicSansMS", size: 17)
    static var Jost: Self = .custom("Jost", size: 17)
    static var Satoshi: Self = .custom("Satoshi Variable", size: 17)
    static var Wingdings: Self = .custom("Wingdings", size: 17)
    static var Mojangles: Self = .custom("Mojangles Extended", size: 17)
}
