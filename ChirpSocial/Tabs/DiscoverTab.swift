//
//  DiscoverTab.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI
struct DiscoverTab: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State var searchResults: [SearchChirp]? = nil
    @State var search = ""
    @State var searchTab = 0
    @State var trends: [Trend] = [Trend(content: "chirp", numChirps: 12), Trend(content: "twitter", numChirps: 47), Trend(content: "iphone 16", numChirps: 62)]
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if searchResults == nil {
                    Text("Search").padding(.horizontal).padding(.top).font(themeManager.currentTheme.UIFont.value)
                    TextField("", text: $search, prompt: Text("What are you looking for?").font(themeManager.currentTheme.UIFont.value))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onSubmit {
                            ChirpAPI().search(searchTerm: search, callback: { success, error, chirps in
                                if success {
                                    searchResults = chirps
                                } else {
                                    Drops.show("Error")
                                }
                            })
                        }
                        .submitLabel(.search)
                    
                    Text("Trends").padding(.horizontal).padding(.top).font(themeManager.currentTheme.UIFont.value)
                    VStack(alignment: .leading) {
                        ForEach(trends) { t in
                            TrendListElement(trend: t).onTapGesture {
                                search = t.content
                                ChirpAPI().search(searchTerm: t.content, callback: { success, error, chirps in
                                    if success {
                                        searchResults = chirps
                                    } else {
                                        Drops.show("Error")
                                    }
                                })
                            }
                            if trends.last != t {
                                Divider()
                            }
                        }
                    }.modifier(list()).padding(.horizontal)
                    Text("Suggested Accounts").padding(.horizontal).padding(.top).font(themeManager.currentTheme.UIFont.value)
                    VStack(alignment: .leading) {
                        ProfileInfoView(chirp: nil, user: User(id: 0, name: "Apple", username: "apple", bannerPic: "", profilePic: "https://pbs.twimg.com/profile_images/1797665112440045568/305XgPDq_400x400.png", followingCount: 0, followersCount: 0, joinedDate: "", bio: ""))
                        Divider()
                        ProfileInfoView(chirp: nil, user: User(id: 0, name: "President Biden", username: "POTUS", bannerPic: "", profilePic: "https://pbs.twimg.com/profile_images/1380530524779859970/TfwVAbyX_400x400.jpg", followingCount: 0, followersCount: 0, joinedDate: "", bio: ""))
                        Divider()
                        ProfileInfoView(chirp: nil, user: User(id: 0, name: "Chirp", username: "chirp", bannerPic: "", profilePic: "https://pbs.twimg.com/profile_images/1797665112440045568/305XgPDq_400x400.png", followingCount: 0, followersCount: 0, joinedDate: "", bio: ""))
                    }.modifier(list()).padding(.horizontal)
                    
                } else {
                    HStack {
                        Button("", systemImage: "arrow.left") {
                            searchResults = nil
                        }
                        TextField("", text: $search, prompt: Text("What are you looking for?"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onSubmit {
                                ChirpAPI().search(searchTerm: search, callback: { success, error, chirps in
                                    if success {
                                        searchResults = chirps
                                    } else {
                                        Drops.show("Error")
                                    }
                                })
                            }
                            .submitLabel(.search)
                    }
                    CustomTabView(tab: $searchTab, tabs: ["Chirps", "Rechirps"])
                    ScrollView {
                        if searchTab == 0 {
                            ForEach((searchResults?.filter {$0.type == "post"})!) {chirp in
                                Text(chirp.chirp)
                                Divider()
                            }
                        } else {
                            ForEach((searchResults?.filter {$0.type == "reply"})!) {chirp in
                                Text(chirp.chirp)
                                Divider()
                            }
                        }
                        
                    }.padding()
                }
                Spacer()
            }.navigationTitle(searchResults == nil ? "Discover" : "")
        }
    }
}

struct TrendListElement: View {
    @EnvironmentObject var themeManager: ThemeManager
    var trend: Trend
    var body: some View {
        Text(trend.content).font(themeManager.currentTheme.UIFont.value)
        Text("\(trend.numChirps) chirps").foregroundStyle(.gray).font(themeManager.currentTheme.UIFont.value)//15
    }
}
struct Trend: Identifiable, Equatable {
    let id: UUID = UUID()
    var content: String
    let numChirps: Int
}
#Preview {
    DiscoverTab()
}

import Drops
struct SearchResultsView: View {
    @State var chirps: [SearchChirp]?
    var search: String
    var body: some View {
        VStack {
            if chirps == nil {
                ProgressView()
            } else {
                ForEach(chirps!) { chirp in
                    Text(chirp.chirp)
                }
            }
        }.onAppear() {
            ChirpAPI().search(searchTerm: search, callback: { success, error, chirpResults in
                if success {
                    chirps = chirpResults
                } else {
                    Drops.show("Error")
                }
            })
        }
    }
}
