//
//  HomeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

struct HomeView: View {
    @State var tab: Tab = .forYou
    var body: some View {
        VStack {
            Image("Chirpie")
            Picker("", selection: $tab) {
                Text("For You").tag(Tab.forYou)
                Text("Following").tag(Tab.following)
            }.pickerStyle(.palette)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

enum Tab {
    case forYou
    case following
}
