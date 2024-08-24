//
//  Utility.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/16/24.
//
import LinkPreview
import SwiftUI
import AVKit

class Utility {
    func errorAlert(_ message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        rootViewController.present(alert, animated: true, completion: nil)
        //DispatchQueue.main.async {
         //   UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        //}
    }
    func content(_ content: String) -> some View {
        var images: [String] = []
        var mentions: [Mention] = []
        var links: [String] = []
        var text: [String] = []
        var videos: [String] = []
        let parts = content.replacingOccurrences(of: "<br />", with: " \n ").replacingOccurrences(of: "&#039;", with: "'").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: "").split(separator: " ")
        for index in 0..<parts.count {
            let part = parts[index]
            if part.starts(with: "@") {
                mentions.append(Mention(text: String(part), after: index-1))
                text.append(String(part))
            } else if String(part).replacingOccurrences(of: "\n", with: "").starts(with: "http") {
                if String(part).contains("twimg") {
                    images.append(String(part).replacingOccurrences(of: "amp;", with: "").replacingOccurrences(of: "\n", with: ""))
                } else if part.contains(".mp4") {
                    videos.append(String(part))
                } else if let url = URL(string: String(part)) {
                    links.append(String(part))
                }
            } else if part.contains(".com") || part.contains(".org") || part.contains(".net") || part.contains(".xyz"){
                links.append("https://"+String(part))
            } else {
                text.append(String(part))
            }
        }
        var AttributedText: AttributedString = AttributedString(text.joined(separator: " "))
        print("parts: \(parts)")
        print("links: \(links)")
        print("images: \(images)")
        print("texts: \(text)")
        print("mentions: \(mentions)")
        print("videos: \(videos)")
        for mention in mentions {
            if let range =  AttributedText.range(of: mention.text) {
                AttributedText[range].foregroundColor = .accent
                print("yes")
            }
        }
        return VStack {
            HStack {
                Text(AttributedText)
                Spacer()
            }
            ForEach(images, id: \.self) { image in
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: image)!) { i in
                        i.resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 300, maxHeight: 300).clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
            }
            ForEach(links, id: \.self) { link in
                LinkPreview(url: URL(string: link))
            }
            ForEach(videos, id: \.self) { video in
                VideoPlayer(player: AVPlayer(url:  URL(string: "https://lukatv.lol/yes/yes.mp4")!)).frame(width: 200)
            }
        }.multilineTextAlignment(.leading)
    }
}
