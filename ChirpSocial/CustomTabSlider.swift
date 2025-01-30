//
//  CustomTabSlider.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/19/24.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var themeMangaer: ThemeManager
    @Binding var tab: Int
    var tabs: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(self.tabs, id:\.self) { tab in
                    HStack {
                        Spacer()
                        Text(tab).font(themeMangaer.currentTheme.UIFont.value)
                        Spacer()
                    }.onTapGesture {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                        withAnimation {
                            self.tab = self.tabs.firstIndex(of: tab) ?? 0
                        }

                        //withAnimation(animation: .spring()) {
                        //    self.tab = self.tabs.firstIndex(of: tab) ?? 0
                        //}
                    }
                    .padding(.vertical, 16)
                    .tint(self.tab == (self.tabs.firstIndex(of: tab) ?? 0) ? .accentColor :  .gray)
                }
            }
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: UIScreen.main.bounds.width, height: 1)
            Rectangle()
                .fill(Color.accentColor)
                .frame(width: UIScreen.main.bounds.width/CGFloat(tabs.count), height: 2, alignment: .leading)
                .offset(x: UIScreen.main.bounds.width/CGFloat(tabs.count)*CGFloat(self.tab), y: -1.5)
                .background {
                    Color.clear
                }
        }
        //SlidingTabView(selection: $tab, tabs: tabs, font: .custom("Jost", size: 17), animation: .default, activeAccentColor: Color.accent, inactiveAccentColor: Color.gray, selectionBarColor: Color.accent, inactiveTabColor: .clear, activeTabColor: .clear)
    }
}

#Preview {
    CustomTabView(tab: .constant(0), tabs: ["For You", "Following"])
}
