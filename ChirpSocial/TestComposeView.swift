//
//  TestComposeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 12/21/24.
//
import SwiftUI
import Kingfisher

struct TCompView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presMode
    @State var replyingTo: Chirp?
    @State var chirpContent: String = ""
    var body: some View {
        if #available(iOS 16.4, *) {
            VStack {}.presentationBackground(.clear)
        }
        ZStack {
            //ChirpDetailView(chirp: Chirp._default)
            Color.gray.opacity(0.2).ignoresSafeArea()
            VStack {
                HStack {
                    Button("Cancel") {
                        presMode.wrappedValue.dismiss()
                    }.foregroundStyle(Color("red")).font(.Jost)
                    Button("Replying to @" + replyingTo!.username) {
                        //change who ur replying to or something
                    }.foregroundStyle(.secondary).padding(.horizontal).font(.Jost)
                    Spacer()
                    Button {
                    } label: {
                        Text(replyingTo == nil ? "Chirp" : "Reply")
                            .font(.Jost)
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .background(Color(.accent))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                HStack {
                    VStack {
                        KFImage(URL(string: replyingTo!.profilePic))
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        Text(replyingTo!.name).font(.Jost)
                        ChirpContentView(chirp: replyingTo!).foregroundStyle(.secondary)
                    }
                }.padding().background(.gray.opacity(0.25)).clipShape(
                    RoundedRectangle(cornerRadius: 10))
                TextEntryWithPlaceholder(text: $chirpContent)
                Spacer()
                HStack {
                    Spacer()
                    Text(String(500 - chirpContent.count))
                    ZStack {
                        Circle()
                            .stroke(
                                Color.secondary,
                                lineWidth: 2.5
                            )
                        Circle()
                            .trim(
                                from: 0, to: CGFloat(chirpContent.count) / 500.0
                            )
                            .stroke(
                                Color.accentColor,
                                // 1
                                style: StrokeStyle(
                                    lineWidth: 2.5,
                                    lineCap: .square
                                )
                            )
                            .rotationEffect(.degrees(-90))
                    }.frame(width: 15, height: 15).padding()

                }
            }.padding().frame(height: 400).background(colorScheme == .dark ? Color.black : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10)).padding()
        }.ignoresSafeArea()
    }
}

#Preview {
    TCompView(replyingTo: ._default)
        .environmentObject(ThemeManager())
}

struct TextEntryWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String = "What's on your mind?"
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $text).opacity(text.isEmpty ? 0.3 : 1).font(.Satoshi)
                .background {
                    if text.isEmpty {
                        VStack {
                            HStack {
                                Text(placeholder).padding(.horizontal, 5)
                                    .padding(.vertical, 7.5).font(.Jost)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
        }
    }
}
