//
//  ContentView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    @State var tab = 0
    var body: some View {
        TabView(selection: $tab) {
            HomeView().tabItem {
                Image("house")
            }.tag(0)
            DiscoverTab().tabItem {
                Image("search")
                if (tab == 1) {
                    Color.accentColor
                }
            }.tag(1)
            NotificationsTab().tabItem {
                Image("bell")
            }.tag(2)
            MessagesTab().tabItem {
                Image("envelope")
            }.tag(3)
            ProfileTab().tabItem {
                Image("person")
            }.tag(4)
        }.onAppear {
            UITextView.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "jost"))
            UITabBar.appearance().itemSpacing = 80
        }
    }
}

#Preview {
    ContentView()
}


extension UILabel {
    @objc var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}

extension UITextView {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    @objc var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
