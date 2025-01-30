//
//  ThemesView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/28/24.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 0) {
            NavigationHeader(headerText: "Themes", backText: "Settings").padding(.bottom)
            ScrollView {
                VStack {
                    LazyVGrid(columns: [.init(.flexible(minimum: 60)),.init(.flexible(minimum: 60)),.init(.flexible(minimum: 60))]) {
                        ForEach(themeManager.availableThemes) { theme in
                            VStack {
                                Text(theme.name).font(themeManager.currentTheme.UIFont.value)
                                ZStack {
                                    if(themeManager.currentTheme.name == theme.name) {
                                        Color.white.frame(width: 70, height: 70).clipShape(Circle())
                                        
                                    }
                                    Color(theme.color).frame(width: 60, height: 60).clipShape(Circle())
                                }
                                //Circle()
                                //Circle().stroke(.white, lineWidth: themeManager.currentTheme.name == theme.name ? 10 : 0).fill(Color(theme.color)).frame(width: 60, height: 60)
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
