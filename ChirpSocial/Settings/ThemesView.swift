//
//  ThemesView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/28/24.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [.init(.flexible(minimum: 60)),.init(.flexible(minimum: 60)),.init(.flexible(minimum: 60))]) {
                        ForEach(themeManager.availableThemes) { theme in
                            VStack {
                                Text(theme.name).font(themeManager.currentTheme.UIFont.value)
                                
                                if #available(iOS 17.0, *) {
                                    Circle().stroke(.white, lineWidth: themeManager.currentTheme.name == theme.name ? 10 : 0).fill(Color(theme.color)).frame(width: 60, height: 60)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }.onTapGesture {
                                themeManager.setTheme(theme)
                            }
                        }
                    }
                }
            }
        }.navigationTitle(String(localized: "themes"))
    }
}

#Preview {
    ThemesView()
}
