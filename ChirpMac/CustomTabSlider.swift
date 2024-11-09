//
//  CustomTabSlider.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/19/24.
//

import SwiftUI

struct CustomTabView: View {
    //@EnvironmentObject var themeMangaer: ThemeManager
    @Binding var tab: Int
    var tabs: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(self.tabs, id:\.self) { tab in
                    HStack {
                        Spacer()
                        Text(tab)//.font(themeMangaer.currentTheme.UIFont.value)
                        Spacer()
                    }.onTapGesture {
                        self.tab = self.tabs.firstIndex(of: tab) ?? 0
                    }
                    .padding(.vertical, 16)
                    .tint(self.tab == (self.tabs.firstIndex(of: tab) ?? 0) ? .accentColor :  .gray)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: geometry.size.width / CGFloat(tabs.count), height: 2, alignment: .leading)
                        .offset(x: ( geometry.size.width/CGFloat(tabs.count))*CGFloat(self.tab), y: 0)
                        .animation(.spring())
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: geometry.size.width, height: 1, alignment: .leading)
                }.fixedSize(horizontal: false, vertical: true)
            }.fixedSize(horizontal: false, vertical: true)
            
        }
        //SlidingTabView(selection: $tab, tabs: tabs, font: .custom("Jost", size: 17), animation: .default, activeAccentColor: Color.accent, inactiveAccentColor: Color.gray, selectionBarColor: Color.accent, inactiveTabColor: .clear, activeTabColor: .clear)
    }
}

#Preview {
    CustomTabView(tab: .constant(0), tabs: ["For You", "Following"])
}
