//
//  ThemeManger.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/28/24.
//
import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme
    @Published var availableThemes: [Theme]
    init() {
        self.currentTheme = Utility.shared.getTheme()
        self.availableThemes = [
            Theme(name: "Christmas", color: "red", icon: "ChirpieC", appIcon: "AppIconC"),
            Theme(name: "Halloween", color: "orange", icon: "ChirpieH", appIcon: "AppIconH"),
            Theme(name: "Pink", color: "pink"),
            Theme(name: "Purple", color: "purple"),
            Theme(name: "Orange", color: "orange"),
            Theme(name: "Blue", color: "blue"),
            Theme(name: "Green", color: "green"),
            Theme(name: "brat", color: "brat", appIcon: "AppIconBrat", UIFont: .Brat, PostFont: .Brat),
            Theme(name: "Comic Sans", color: "green", UIFont: .ComicSans, PostFont: .ComicSans),
            Theme(name: "Wingdings", color: "green", UIFont: .Wingdings, PostFont: .Wingdings),
            Theme(name: "Mojangles", color: "minecraft", UIFont: .Mojangles, PostFont: .Mojangles)
        ]
    }
    func setTheme(_ theme: Theme) {
        Utility.shared.setTheme(theme)
        self.currentTheme = theme
        if Utility.shared.getAppIcon() != theme.appIcon {
            Utility.shared.setAppIcon(theme.appIcon)
        }
    }
}
