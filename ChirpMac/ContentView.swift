//
//  ContentView.swift
//  ChirpMac
//
//  Created by Andrew Smiley on 10/30/24.
//

import SwiftUI
import Subsonic
import Drops
import Alamofire

struct ContentView: View {
    @StateObject var navigationController = NavigationController()
    @State private var selectedTab: Int? = 0
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                HStack {
                    Image("Chirpie")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    Spacer()
                }.padding()
                VStack(spacing: 20) {
                    NavigationButton(title: "Home", icon: "home", tag: 0)
                    NavigationButton(title: "Discover", icon: "discover", tag: 1)
                    NavigationButton(title: "Notifications", icon: "bell", tag: 2)
                    NavigationButton(title: "Direct Messages", icon: "envelope", tag: 3)
                    NavigationButton(title: "Profile", icon: "person", tag: 4)
                }
                .padding(.horizontal)
                Text("Chirp")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .cornerRadius(24)
                    .onTapGesture {
                        //do chirp popover
                    }
                    .padding()
                Spacer()
                
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading) {
                        Text("Andrew")
                            .font(.headline)
                        Text("@smileyzone")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "gear")
                }
                .padding()
            }
            .frame(width: 250)
            .background(Color(.black))
            Divider()
            VStack {
                switch navigationController.sideBarTab {
                case 1:
                    HStack {
                        Spacer()
                        Text("Discover View")
                    }
                case 2:
                    HStack {
                        Spacer()
                        Text("Notifications View")
                    }
                case 3:
                    HStack {
                        Spacer()
                        Text("Direct Messages View")
                    }
                case 4:
                    HStack {
                        Spacer()
                        Text("Profile View")
                    }
                    //ProfileView()
                default:
                    switch navigationController.centerContent {
                    case .home:
                        FeedView()
                    case .chirp(let chirp):
                        VStack {
                            HStack {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Chirp")
                                }.onTapGesture {
                                    navigationController.centerContent = .home
                                }
                                .foregroundStyle(.primary)
                                .padding()
                                Spacer()
                            }
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(maxWidth: .infinity, maxHeight: 2)
                            ChirpListElementView(chirp: chirp, skeleton: false)
                            Spacer()
                        }
                    default:
                        FeedView()
                    }
                    
                }
            }.frame(minWidth: 300)
            Divider()
            VStack {
                Text("trends")
            }.frame(minWidth: 300)
        }
        .background(Color.black)
        .environmentObject(navigationController)
    }
}

struct NavigationButton: View {
    @EnvironmentObject var navigationController: NavigationController
    let title: String
    let icon: String
    let tag: Int
    
    var body: some View {
        HStack {
            HStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(navigationController.sideBarTab == tag ? .primary : .secondary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(navigationController.sideBarTab == tag ? Color(Color.accent) : Color.clear)
            .cornerRadius(24)
            Spacer()
        }
        .onTapGesture {
            navigationController.sideBarTab = tag
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

// Your imports remain the same

struct FeedView: View {
    
    @State var chirps: [Chirp] = []
    @EnvironmentObject var navigationController: NavigationController
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(chirps) { chirp in
                    ChirpListElementView(chirp: chirp, skeleton: false)
                }
            }
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.listStyle(.plain)
            //.scrollContentBackground(.hidden)
            .onAppear(perform: loadChirps)
            Spacer()
        }
    }
    
    private func loadChirps() {
        let headers: HTTPHeaders = ["Content-Type": "application/json" ]
        AF.request("https://beta.chirpsocial.net/fetch_chirps.php?offset=0", headers: headers).responseDecodable(of: [Chirp].self) { response in
            switch response.result {
            case .success(let chirps):
                self.chirps = chirps
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

struct ChirpRowView: View {
    let chirp: Chirp
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                AsyncImage(url: URL(string: chirp.profilePic)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(chirp.name)
                        .font(.headline)
                    Text("@\(chirp.username)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(Date(timeIntervalSince1970: Double(chirp.timestamp)), style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            
            
            HStack(spacing: 16) {
                Label("\(chirp.replyCount)", systemImage: "bubble.left")
                Label("\(chirp.rechirpCount)", systemImage: "arrow.2.squarepath")
                Label("\(chirp.likeCount)", systemImage: chirp.likedByCurrentUser ? "heart.fill" : "heart")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// Preview
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

// End of file. No additional code.
