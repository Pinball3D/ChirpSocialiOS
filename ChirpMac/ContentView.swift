//
//  ContentView.swift
//  ChirpMac
//
//  Created by Andrew Smiley on 10/30/24, modified by @timi2506 on 01/30/25.
//

import SwiftUI
import Subsonic
import Drops
import Alamofire

struct ContentView: View {
    @StateObject var navigationController = NavigationController()
    @State private var selectedTab: Int? = 0
    @Binding var needsToRefresh: Bool
    @State var smallSideBar = false
    @State var searchText = ""
    
    var body: some View {
            
            NavigationView {
                GeometryReader { geometry in

                VStack(spacing: 0) {
                    Divider().ignoresSafeArea(.all)
                    VStack(spacing: 0) {
                        NavigationButton(title: "Home", icon: "home", tag: 0, smallSideBar: $smallSideBar)
                        NavigationButton(title: "Discover", icon: "discover", tag: 1, smallSideBar: $smallSideBar)
                        NavigationButton(title: "Notifications", icon: "bell", tag: 2, smallSideBar: $smallSideBar)
                        NavigationButton(title: "Direct Messages", icon: "envelope", tag: 3, smallSideBar: $smallSideBar)
                        NavigationButton(title: "Profile", icon: "person", tag: 4, smallSideBar: $smallSideBar)
                    }
                    Text(smallSideBar ? "􀅼" : "Chirp")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(Color.accent)
                                .cornerRadius(24)
                    .onTapGesture {
                        //do chirp popover
                    }
                    .padding(10)
                    Spacer()
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                        if !smallSideBar {
                            VStack(alignment: .leading) {
                                Text("Andrew")
                                    .font(.headline)
                                Text("@smileyzone")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                    }
                    .padding()
                    
                }
                .onAppear {
                    if geometry.size.width < 166.0 {
                        smallSideBar = true
                    }
                }
                .onChange(of: geometry.size.width) { newValue in
                    if geometry.size.width < 166.0 {
                        smallSideBar = true
                    }
                    if geometry.size.width > 166.0 {
                        smallSideBar = false
                    }
                }
                }
                .frame(minWidth: 1)
                .listStyle(.sidebar)
                .animation(.smooth())
                
                HStack {
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
                                FeedView(needsToRefresh: $needsToRefresh)
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
                                FeedView(needsToRefresh: $needsToRefresh)
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.never)
                    .frame(minWidth: 250)
                        .ignoresSafeArea(.all)
                        .background(.ultraThinMaterial)

                    VStack {
                        List {
                            TextField("Search Chirp", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Section("Trends") {
                                VStack {
                                    Group {
                                        Text("chirp")
                                        Text("12 chirps")
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                VStack {
                                    Group {
                                        Text("twitter")
                                        Text("47 chirps")
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                VStack {
                                    Group {
                                    Text("iphone 16")
                                    Text("62 chirps")
                                        .foregroundStyle(.gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            Section("Suggested Accounts") {
                                RecommendedUserView(userImageURL: URL(string: "https://pbs.twimg.com/profile_images/1797665112440045568/305XgPDq_400x400.png")!, name: "Apple", username: "apple", verified: true)
                                RecommendedUserView(userImageURL: URL(string: "https://pbs.twimg.com/profile_images/1881368435453542400/NnD56DYV_400x400.jpg")!, name: "President Trump", username: "POTUS", verified: true)
                                RecommendedUserView(userImageURL: URL(string: "https://pbs.twimg.com/profile_images/1852687705823395840/h2Cqbe8i_400x400.jpg")!, name: "Chirp", username: "chirp", verified: true)
                            }
                        }
                        .listStyle(SidebarListStyle())
                    }
                    .frame(minWidth: 175, maxWidth: 175)
                }
            }
            .environmentObject(navigationController)
            
    }
}

struct NavigationButton: View {
    @EnvironmentObject var navigationController: NavigationController
    let title: String
    let icon: String
    let tag: Int
    @Binding var smallSideBar: Bool
    
    var body: some View {
        VStack {
            if navigationController.sideBarTab == tag {
                HStack {
                    HStack {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 10)
                        if !smallSideBar {
                            Text(title)
                                .font(.body)
                                .foregroundStyle(Color.accent)
                        }
                    }
                    .foregroundColor(navigationController.sideBarTab == tag ? .primary : .secondary)
                    if !smallSideBar {
                        Spacer()
                    }
                }
                .padding(.vertical, 10)
                .background(.gray.opacity(0.25)).contentShape(Rectangle())
                .cornerRadius(smallSideBar ? 15 : .zero)

            }
            else {
                HStack {
                    HStack {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 10)
                        if !smallSideBar {
                            Text(title)
                                .font(.body)
                        }
                    }
                    .foregroundColor(navigationController.sideBarTab == tag ? .primary : .secondary)
                    if !smallSideBar {
                        Spacer()
                    }
                }
                .padding(.vertical, 10)
                .background(.clear).contentShape(Rectangle())
            }
        }
        .onTapGesture {
            navigationController.sideBarTab = tag
        }
    }
}


import SwiftUI

// Your imports remain the same

struct FeedView: View {
    @State var chirpLoadingError = false
    
    @Binding var needsToRefresh: Bool
    @State var chirps: [Chirp] = []
    @EnvironmentObject var navigationController: NavigationController
    var body: some View {
        VStack {
            if chirpLoadingError {
                ChirpFailView()
            }
            else {
                if chirps.isEmpty {
                    VStack {
                        ProgressView()
                        Text("Fetching the latest Chirps just for you...")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
                else {
                    
                    ScrollView {
                        
                        ForEach(chirps) { chirp in
                            ChirpListElementView(chirp: chirp, skeleton: false)
                        }
                    }
                }
            }
            
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.listStyle(.plain)
            //.scrollContentBackground(.hidden)
        }
        .onAppear(perform: loadChirps)
        .onChange(of: needsToRefresh) { newValue in
            if needsToRefresh {
                loadChirps()
            }
        }
        
    }
        
    func loadChirps() {
        chirps = []
        let headers: HTTPHeaders = ["Content-Type": "application/json" ]
        AF.request("https://beta.chirpsocial.net/fetch_chirps.php?offset=0", headers: headers).responseDecodable(of: [Chirp].self) { response in
            switch response.result {
            case .success(let chirps):
                self.chirps = chirps
            case .failure(let error):
                print("Error: \(error)")
                chirpLoadingError = true
            }
        }
        needsToRefresh = false
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



// End of file. No additional code.

struct RecommendedUserView: View {
    let userImageURL: URL
    let name: String
    let username: String
    let verified: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: userImageURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                            .controlSize(.large)
                    }
                .scaledToFit()
                .frame(width: 25,  height: 25)
                .background(.secondary)
                .cornerRadius(100)
            VStack {
                Group {
                    HStack {
                        Text(name)
                        if verified {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                                .scaleEffect(0.75)
                        }
                    }
                    Text("@\(username)")
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
