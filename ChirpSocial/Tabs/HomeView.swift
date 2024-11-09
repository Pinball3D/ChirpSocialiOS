//
//  HomeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI
import Drops
import Subsonic
import SkeletonUI
import Kingfisher
//import Refresher

struct HomeView: View {
    @EnvironmentObject var accountManager: AccountManager
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var themeManager: ThemeManager
    @State var tab: Int = 0
    @State var chirps: [Chirp] = []
    @State var compose = false
    var body: some View {
        NavigationStack(path: $navigationController.route) {
            VStack {
                HStack {
                    Spacer()
                    Image(themeManager.currentTheme.icon).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(height: 36).onTapGesture {
                        play(sound: "Who Let Birds Out.mp3")
                    }
                    Spacer()
                }.overlay {
                    HStack {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            if !accountManager.signedIn {
                                Image("user").resizable().frame(width: 35, height: 35).clipShape(Circle())
                            } else {
                                KFImage(URL(string: accountManager.profile!.profilePic)).resizable().frame(width: 35, height: 35).clipShape(Circle())
                                
                            }
                            
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                CustomTabView(tab: $tab, tabs: [String(localized: "forYou"), String(localized: "following")])//.padding(.horizontal)
                ZStack {
                    ChirpListView(type: .forYou).disabled(tab == 1).opacity(tab == 1 ? 0 : 1)
                    ChirpListView(type: .following).disabled(tab == 0).opacity(tab == 0 ? 0 : 1)
                }
                Spacer()
            }
            .navigationTitle("Chirp")
            .navigationBarHidden(true)
            .overlay {
                if accountManager.signedIn {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                navigationController.composeView = true
                            } label: {
                                Text(String(localized: "Chirp")).font(themeManager.currentTheme.UIFont.value).bold()
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.black)
                            .padding()
                            .disabled(UserDefaults.standard.string(forKey: "PHPSESSID") == "")
                            
                        }
                    }
                }
            }
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .profile(let username):
                    ProfileView(username: username)
                case .chirp(let id):
                    Text("[Home View] route to chirp with id \(id)")
                case .notification(let id):
                    Text("[Home View] route to notification with id \(id)")
                case .image(let string):
                    Text("[Home View] route to image with string \(string)")
                }
            })
        }.fullScreenCover(isPresented: $navigationController.composeView) {
            ComposeView()
        }
    }
}

#Preview {
    HomeView()
}

enum Tab {
    case forYou
    case following
}
