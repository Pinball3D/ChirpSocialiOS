//
//  ChirpListElementView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/19/24.
//

import SwiftUI
import SkeletonUI
import Kingfisher
import LinkPresentation
import SwiftUI
import SwiftSoup
//import LinkPreview

struct ChirpListElementView: View {
    //@EnvironmentObject var themeManager: ThemeManager
    @State var timestamp: String = ""
    var chirp: Chirp
    var skeleton: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ProfileInfoView(chirp: chirp, user: nil, disableHyperlink: true, skeleton: skeleton)
                Spacer()
                if skeleton {
                    Text(timestamp)//.font(themeManager.currentTheme.UIFont.value).skeleton(with: skeleton).frame(width: 100, height: 25)
                } else { Text(timestamp)//.font(themeManager.currentTheme.UIFont.value) }
                }
            }
            .padding(.top)
            if skeleton {
                Text("").skeleton(with: skeleton, lines: 3)
            } else {
                ChirpContentView(chirp: chirp)
            }
            Divider().ignoresSafeArea(.all)
            InteractionBar(chirp: chirp).padding(.vertical, 2.5).disabled(skeleton)
            Divider().ignoresSafeArea(.all)

        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                if !skeleton {
                    let date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(chirp.timestamp)))
                    var formatter: RelativeDateTimeFormatter {
                        let dtf = RelativeDateTimeFormatter()
                        dtf.unitsStyle = .abbreviated
                        return dtf
                    }
                    timestamp = formatter.localizedString(for: date, relativeTo: Date())
                }
            })
        }
    }
    
    struct ChirpContentView: View {
        //@EnvironmentObject var themeManager: ThemeManager
        var chirp: Chirp
        var soup: Document? {
            do {
                return try SwiftSoup.parse(chirp.chirp)
            } catch {
                return nil
            }
        }
        var images: [String] {
            var images: [String] = []
            do {
                if let imgs = try soup?.getElementsByClass("imageInChirp") {
                    for img in imgs {
                        images.append(try img.attr("src"))
                        try img.remove()
                    }
                }
                return images
            } catch {
                return images
            }
        }
        var mentions: [String] {
            var mentions: [String] = []
            do {
                let lnks = try soup!.getElementsByClass("linkInChirp")
                for lnk in lnks {
                    if try lnk.attr("href").hasPrefix("/user/?id=") {
                        try lnk.html(try lnk.text())
                        mentions.append(try lnk.text())
                    }
                }
                return mentions
            } catch {
                return []
            }
        }
        var links: [String] {
            var links: [String] = []
            do {
                let lnks = try soup!.getElementsByClass("linkInChirp")
                for lnk in lnks {
                    if !(try lnk.attr("href").hasPrefix("/user/?id=")) {
                        links.append(try lnk.attr("href"))
                        try lnk.remove()
                    }
                }
                return links
            } catch {
                return []
            }
        }
        var text: String {
            do {
                let rawTextSoup = soup!
                for element in try rawTextSoup.getElementsByClass("ytEmbedder") {
                    try element.remove()
                }
                for element in try rawTextSoup.getElementsByClass("imageInChirp") {
                    try element.remove()
                }
                for element in try rawTextSoup.getElementsByClass("linkInChirp") {
                    if !(try element.attr("href").hasPrefix("/user/?id=")) {
                        try element.remove()
                    }
                }
                return try rawTextSoup.text()
            } catch {
                return ""
            }
        }
        var ytEmbeds: [YtEmbed] {
            var ytEmbeds: [YtEmbed] = []
            do {
                for embed in try soup!.getElementsByClass("ytEmbedder") {
                    var youtubeEmbed = YtEmbed(originalURL: "''", title: "", description: "", photo: "")
                    youtubeEmbed.originalURL = try embed.attr("href")
                    try embed.remove()
                    if embed.children().count == 1 {
                        youtubeEmbed.photo = try embed.children()[0].children()[0].attr("src")
                        youtubeEmbed.title = try embed.children()[0].children()[1].getElementsByClass("titleEmbed").text()
                        youtubeEmbed.description = try embed.children()[0].children()[1].getElementsByClass("descriptionEmbed").text()
                        ytEmbeds.append(youtubeEmbed)
                    }
                }
                return ytEmbeds
            } catch {
                return ytEmbeds
            }
        }
        var AttributedChirp: Text {
            var AttributedChirp = Text("")
            print(text)
            for word in text.split(separator: " ") {
                var added = false
                for mention in mentions {
                    print("[Attr mention: \(mention), word: \(word)]")
                    if word.contains(mention) {
                        var AttrMention = AttributedString(mention)
                        AttrMention.foregroundColor = .accentColor
                        AttrMention.link = URL(string: "chirp://user/"+mention.replacingOccurrences(of: "@", with: ""))
                        AttributedChirp = AttributedChirp + Text(AttrMention)
                        added = true
                    }
                }
                if !added {
                    AttributedChirp = AttributedChirp + Text(word)
                }
                if word != text.split(separator: " ").last {
                    AttributedChirp = AttributedChirp + Text(" ")
                }
            }
            return AttributedChirp
        }
        @EnvironmentObject var navigationController: NavigationController
        var expanded = false
        var chirpSeesNote: String? = nil
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    AttributedChirp//.font(themeManager.currentTheme.PostFont.value).multilineTextAlignment(.leading)
                    Spacer()
                }.onTapGesture {
                    navigationController.centerContent = .chirp(chirp)
                }
                ForEach(images, id: \.self) { image in
                    KFImage(URL(string: image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .onTapGesture {
                            // UIApplication.shared.open(URL(string: "chirp://image/"+image)!)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 1)
                        )
                }.frame(maxWidth: .infinity)
                ForEach(links, id: \.self) { link in
                    LinkEmbed(url: URL(string: link)!)
                }.frame(maxWidth: .infinity)
                ForEach(ytEmbeds) { embed in
                    Link(destination: URL(string: embed.originalURL)!) {
                        HStack {
                            KFImage(URL(string: embed.photo)).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(width: 190).clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 0, topTrailingRadius: 0))
                            VStack(alignment: .leading) {
                                Text("youtube.com").font(.caption).foregroundStyle(.secondary)
                                Text(embed.title).bold().multilineTextAlignment(.leading)
                                Text(embed.description).lineLimit(1).multilineTextAlignment(.leading)
                            }.frame(maxWidth: .infinity).padding(.vertical).layoutPriority(1)
                            Spacer()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 1)
                        )
                        
                    }.tint(.primary)
                }.frame(maxWidth: .infinity)
                if false {//chirp.chirp != Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://yt3.ggpht.com/UizvF2n7TBnRUsiadJqDU4ihnLsrEutlJ0DYwCT2HlrrHxgm4vUa1wA1E5cgWl95K-xmltHeWlM=s48-c-k-c0x00ffffff-no-rj", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false).chirp {
                    NavigationLink {
                        //ChirpDetailView(chirp: Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://yt3.ggpht.com/UizvF2n7TBnRUsiadJqDU4ihnLsrEutlJ0DYwCT2HlrrHxgm4vUa1wA1E5cgWl95K-xmltHeWlM=s48-c-k-c0x00ffffff-no-rj", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
                    } label: {
                        VStack {
                            HStack {
                                //ProfileInfoView(chirp: Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://yt3.ggpht.com/UizvF2n7TBnRUsiadJqDU4ihnLsrEutlJ0DYwCT2HlrrHxgm4vUa1wA1E5cgWl95K-xmltHeWlM=s48-c-k-c0x00ffffff-no-rj", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false), user: nil, disableHyperlink: true)
                                Spacer()
                            }
                            ChirpContentView(chirp: Chirp(id: 5326, user: 166, type: "post", chirp: "Hey people", parent: nil, timestamp: 1723679455, via: nil, username: "ILoveRoadBlocks", name: "ddfdfdf", profilePic: "https://yt3.ggpht.com/UizvF2n7TBnRUsiadJqDU4ihnLsrEutlJ0DYwCT2HlrrHxgm4vUa1wA1E5cgWl95K-xmltHeWlM=s48-c-k-c0x00ffffff-no-rj", isVerified: false, likeCount: 7, rechirpCount: 8, replyCount: 9, likedByCurrentUser: false, rechirpedByCurrentUser: false))
                        }
                    }
                    .foregroundStyle(.primary)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 1)
                    ).frame(maxWidth: .infinity)
                }
            }.onAppear {
                print("[ChirpTestView] [onAppear]")
                print("ChirpTestView: \(self.text)")
                print("ChirpTestView: \(self.images)")
                //ytembeds
                print("ChirpTestView: \(self.ytEmbeds)")
            }
        }
        
    }
    
    struct LinkEmbed: View {
        @ObservedObject var fetcher = LinkMetadataFetcher()
        var url: URL
        var body: some View {
            Link(destination: url) {
                HStack {
                    if let metadata = fetcher.metadata {
                        if let image = metadata.imageProvider {
                            LinkImageView(imageProvider: image).clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 0, topTrailingRadius: 0))
                        } else if let icon = metadata.iconProvider {
                            LinkImageView(imageProvider: icon).clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 0, topTrailingRadius: 0))
                        }
                        VStack(alignment: .leading) {
                            Text(metadata.title).bold().multilineTextAlignment(.leading)
                            Text(metadata.originalURL?.host()).font(.caption).foregroundStyle(.secondary)
                        }.frame(maxWidth: .infinity).padding(.vertical).layoutPriority(1)
                        Spacer()
                    } else {
                        KFImage(URL(string: "https://"+url.host()!.lowercased()+"/favicon.ico")).resizable().scaledToFit().frame(maxHeight: 50).clipShape(RoundedRectangle(cornerRadius: 20)).padding()
                        Text(url.host()?.lowercased()).padding()
                        Spacer()
                    }
                }.overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            .tint(.primary)
            .onAppear {
                print("METADATA "+"https://"+url.host()!+"/favicon.ico")
                fetcher.fetchMetadata(for: url)
            }
        }
    }
    
    class LinkMetadataFetcher: ObservableObject {
        @Published var metadata: LPLinkMetadata?
        @Published var isLoading = false
        
        func fetchMetadata(for url: URL) {
            isLoading = true
            let metadataProvider = LPMetadataProvider()
            metadataProvider.startFetchingMetadata(for: url) { [weak self] metadata, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let metadata = metadata {
                        self?.metadata = metadata
                    } else {
                        print("Error fetching metadata: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
    
    
    struct LinkImageView: View {
        let imageProvider: NSItemProvider
        
        @State private var image: NSImage? = nil
        
        var body: some View {
            Group {
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray
                        .onAppear {
                            loadImage()
                        }
                }
            }
        }
        
        func loadImage() {
            imageProvider.loadObject(ofClass: NSImage.self) { object, error in
                DispatchQueue.main.async {
                    if let image = object as? NSImage {
                        self.image = image
                    }
                }
            }
        }
    }
}
