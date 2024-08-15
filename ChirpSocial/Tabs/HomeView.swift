//
//  HomeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/14/24.
//

import SwiftUI

struct HomeView: View {
    @State var tab: Tab = .forYou
    @State var chirps: [Chirp] = []
    @ObservedObject var chirpAPI: ChirpAPI = ChirpAPI()
    @State var compose = false
    @State var popover = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image("Chirpie")
                    Spacer()
                }.overlay {
                    HStack {
                        Button(action: {
                            popover.toggle()
                        }, label: {
                            Image("user")
                        })
                        Spacer()
                    }
                }
                Picker("", selection: $tab) {
                    Text("For You").tag(Tab.forYou)
                    Text("Following").tag(Tab.following)
                }.pickerStyle(.palette)
                if tab == .forYou {
                    ScrollView {
                        LazyVStack {
                            ForEach(chirps) { chirp in
                                ChirpPreviewView(chirp: chirp)
                            }
                            Text("You've Reached the End....").onAppear() {
                                chirpAPI.getNewPosts(offset: chirps.count)
                            }
                        }
                    }
                    .onAppear {
                        chirpAPI.callback = {
                            self.chirps += chirpAPI.chirps
                        }
                        chirpAPI.getNewPosts(offset: chirps.count)
                    }
                    .refreshable {
                        chirps = []
                        chirpAPI.getNewPosts(offset: chirps.count)
                    }
                } else {
                    Text("If you want to use the Following tab you need to follow people first! 😝").multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(.horizontal)
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            compose = true
                        } label: {
                            Text("Chirp").font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.black)
                        .padding()

                    }
                }
            }
        }.popover(isPresented: $popover) {
            if chirpAPI.getSessionToken() != "" {
                Text("you are signed in")
            } else {
                SignInOutView(popover: $popover)
            }
        }.popover(isPresented: $compose) {
            ComposeView(popover: $compose)
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
