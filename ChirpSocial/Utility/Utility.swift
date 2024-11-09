//
//  Utility.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/16/24.
//
//import LinkPreview
import SwiftUI
import AVKit
import SwiftSoup
import Drops
import Kingfisher
import LinkPreview
import LinkPresentation
import Alamofire

class Utility {
    static var shared = Utility()
    @EnvironmentObject var navigationController: NavigationController
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "PHPSESSID")
        UserDefaults.standard.removeObject(forKey: "username")
    }
    func getUser() -> Profile? {
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(Profile.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
    }
    func setUser(_ user: Profile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "user")
        }
    }
    func contentOLD(_ content: String, font: Font? = nil) -> some View {
        var images: [String] = []
        var mentions: [String] = []
        var links: [String] = []
        var text: String = ""
        var ytEmbeds: [YtEmbed] = []
        var chirpsee: Bool = false
        do {
            let soup = try SwiftSoup.parse(content.replacingOccurrences(of: "<br>", with: "\n"))
            //images
            let imgs = try soup.getElementsByClass("imageInChirp")
            for img in imgs {
                images.append(try img.attr("src"))
                try img.remove()
            }
            //links
            let lnks = try soup.getElementsByClass("linkInChirp")
            for lnk in lnks {
                if try lnk.attr("href").hasPrefix("/user/?id=") {
                    try lnk.html(try lnk.text())
                    mentions.append(try lnk.text())
                } else {
                    links.append(try lnk.attr("href"))
                    try lnk.remove()
                }
            }
            if try soup.getElementsByClass("chirpsee").count > 0 {
                try soup.getElementsByClass("chirpsee")[0].remove()
                chirpsee = true
            }
            for embed in try soup.getElementsByClass("ytEmbedder") {
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
            text = try soup.text()
            print("[Chirp Content] Text: \(text)")
        } catch {
            text = content
            Drops.show("An error occoured while loading chirps.")
        }
        var AttributedText: AttributedString = AttributedString(text)
        for mention in mentions {
            if let range = AttributedText.range(of: mention) {
                let username = String(AttributedText[range].characters).replacingOccurrences(of: "@", with: "")
                AttributedText[range].foregroundColor = .accentColor
                AttributedText[range].link = URL(string: "chirp://user/"+username)
            }
        }
        if chirpsee {
            images = []
            links = []
            ytEmbeds = []
        }
        AttributedText.font = .Satoshi
        return VStack {
            if AttributedText.characters.count > 0 {
                HStack {
                    Text(self.parseForTwemoji(AttributedText)).multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            ForEach(images, id: \.self) { image in
                HStack {
                    KFImage(URL(string: image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .onTapGesture {
                            print("[Utility] ASYNC IMAGE TAP")
                            UIApplication.shared.open(URL(string: "chirp://image/"+image)!)
                        }
                }
            }.frame(maxWidth: .infinity)
            ForEach(links, id: \.self) { link in
                //zzLPLinkView(url: URL(string: link))
                LinkPreview(url: URL(string: link))
            }.frame(maxWidth: .infinity)
            ForEach(ytEmbeds) { embed in
                Link(destination: URL(string: embed.originalURL)!) {
                    HStack {
                        KFImage(URL(string: embed.photo)).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(width: 190).clipShape(RoundedRectangle(cornerRadius: 10))
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
                    .padding()
                }.tint(.primary)
            }.frame(maxWidth: .infinity)
            if chirpsee {
                VStack {
                    Text("Media Not Displayed").bold()
                    Text("This image cannot be displayed as it either does not exist or has been removed in response to a legal request or a report by the copyright holder.")
                }.frame(maxWidth: .infinity).padding().background(.secondary.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }.multilineTextAlignment(.leading)
    }
    func getAppIcon() -> String? {
        return UIApplication.shared.alternateIconName
    }
    func setAppIcon(_ icon: String?) {
        UIApplication.shared.setAlternateIconName(icon)
    }
    func getTheme() -> Theme {
        if let savedTheme = UserDefaults.standard.object(forKey: "theme") as? Data {
            let decoder = JSONDecoder()
            if let loadedTheme = try? decoder.decode(Theme.self, from: savedTheme) {
                return loadedTheme
            }
        }
        return Theme.standard
    }
    func setTheme(_ theme: Theme) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(theme) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "theme")
        }
    }
    func parseForTwemoji(_ text: AttributedString) -> AttributedString {
        let AttributedText = text
        //do stuff
        return AttributedText
    }
    func uploadImage(token: String, image: UIImage, completion: @escaping (URL?, String?) -> Void) {
        let githubUsername = "chirpimageupload"
        let repositoryName = "chirp-post-images"
        guard let imgData = image.jpegData(compressionQuality: 0.7) else { return }
        
        let targetFileName = "image-\(UUID().uuidString).jpg"
        let url = "https://api.github.com/repos/\(githubUsername)/\(repositoryName)/contents/\(targetFileName)"
        
        let headers: HTTPHeaders = [
            "Authorization": "token \(token)", // Use the token directly
            "Accept": "application/vnd.github.v3+json"
        ]
        
        let parameters: [String: Any] = [
            "message": "Upload \(targetFileName)",
            "content": imgData.base64EncodedString() // Base64 encode the image data for upload
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: [String: String].self) { response in
            if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let content = json["content"] as? [String: Any],
               let downloadUrl = content["download_url"] as? String {
                completion(URL(string: downloadUrl), nil)
            } else {
                completion(nil, "Error uploading file: \(response.error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    func fetchToken(completion: @escaping (String?, String?) -> Void) {
        AF.request(URL(string: "https://raw.githubusercontent.com/timi2506/chirp-image-uploadtoken/refs/heads/main/token.txt")!).responseString { response in
            switch response.result {
            case .success(let token):
                // Combine the prefix with the fetched token
                completion("ghp_"+token.trimmingCharacters(in: .whitespacesAndNewlines), nil)
            case .failure(let error):
                completion(nil, error.errorDescription)
            }
        }
    }
}


extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

struct YtEmbed: Identifiable {
    let id = UUID()
    var originalURL: String
    var title: String
    var description: String
    var photo: String
}
