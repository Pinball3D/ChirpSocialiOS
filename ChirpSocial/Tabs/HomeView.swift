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
    var chirpAPI: ChirpAPI = ChirpAPI()
    @State var compose = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Image("Chirpie")
                    Spacer()
                }.overlay {
                    HStack {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image("settings").resizable().frame(width: 25, height: 25)
                        }
                        Spacer()
                    }
                }
                Picker("", selection: $tab) {
                    Text("For You").tag(Tab.forYou)
                    Text("Following").tag(Tab.following)
                }.pickerStyle(.segmented)
                if tab == .forYou {
                    ScrollView {
                        VStack {
                            ForEach(0..<chirps.count, id: \.self) { i in
                                if i == chirps.count - 3 {
                                    ChirpPreviewView(chirp: chirps[i])
                                        .background {
                                            LazyVStack {
                                                Color.clear.onAppear {
                                                    print("loading")
                                                     chirpAPI.get(.chirps, offset: chirps.count, callback: { chirps, success, error in
                                                                if success {
                                                                    self.chirps += chirps
                                                        }
                                                    })
                                                }
                                            }
                                        }
                                } else {
                                    ChirpPreviewView(chirp: chirps[i])
                                }
                            }
                            if !chirps.isEmpty {
                                Text("You've Reached the End....").onAppear() {
                                    chirpAPI.get(.chirps, offset: chirps.count, callback: { chirps, success, error in
                                        if success {
                                            self.chirps += chirps
                                        }
                                    })
                                }
                            }
                        }
                    }
                    .onAppear {
                        chirpAPI.get(.chirps, offset: 0, callback: { chirps, success, error in
                            if success {
                                self.chirps = chirps
                            }
                        })
                    }
                    .refreshable {
                        chirpAPI.get(.chirps, offset: 0, callback: { chirps, success, error in
                            if success {
                                self.chirps = chirps
                            }
                        })
                    }
                } else {
                    Text("If you want to use the Following tab you need to follow people first! 😝").multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(.horizontal)
            .overlay {
                if (chirpAPI.getSessionToken() != "") {
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
                            .disabled(UserDefaults.standard.string(forKey: "PHPSESSID") == "")
                
                        }
                    }
                } else { VStack { EmptyView() } }
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
