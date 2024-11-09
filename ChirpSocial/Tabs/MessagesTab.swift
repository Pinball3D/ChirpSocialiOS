//
//  MessagesTab.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI
import Kingfisher

struct MessagesTab: View {
    @State var conversations: [Conversation] = [Conversation(mostRecentMessage: "Ok thanks for the help", otherUser: "Private IcedC81", otherUserImage: "https://pbs.twimg.com/profile_images/1825830809825124352/LcyXmQpJ_400x400.jpg", otherUsername: "PrivateIcedC81"), Conversation(mostRecentMessage: "You: Ok", otherUser: "Chirp", otherUserImage: "https://pbs.twimg.com/profile_images/1798508305687441408/5gv4drcK_400x400.jpg", otherUsername: "chirp")]
    @State var messages = [Message(content: "Hi Chirp!", type: 0), Message(content: "Hi Andrew!", type: 1), Message(content: "This DM's concept is pretty cool right?", type: 0), Message(content: "Yeah it is!", type: 1), Message(content: "Thanks!", type: 0)]
    @AppStorage("DEVMODE") var devMode: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                if devMode {
                    ScrollView {
                        ForEach(conversations) { convo in
                            NavigationLink {
                                ConversationView(messages: $messages, convo: convo)
                            } label: {
                                HStack {
                                    KFImage(URL(string: convo.otherUserImage)).resizable().frame(width: 60, height: 60).clipShape(Circle())
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(convo.otherUser).tint(Color.primary)
                                            Text("@"+convo.otherUsername).foregroundStyle(.secondary).tint(Color.primary)
                                            Spacer()
                                        }
                                        Text(convo.mostRecentMessage).tint(Color.primary)
                                        Spacer()
                                    }
                                }.padding(.horizontal).padding(.vertical, 5)
                            }
                            Divider()
                        }
                        Spacer()
                    }
                }
            }.navigationTitle("Messages")
        }
    }
}

#Preview {
    MessagesTab()
}

struct Conversation: Identifiable {
    var id: UUID = .init()
    var mostRecentMessage: String
    var otherUser: String
    var otherUserImage: String
    var otherUsername: String
}

struct ConversationView: View {
    @FocusState var focued: Bool
    @Binding var messages: [Message]
    var convo: Conversation
    @State var message = ""
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        VStack(alignment: .center) {
                            KFImage(URL(string: convo.otherUserImage)).resizable().frame(width: 75, height: 75).clipShape(Circle())
                            Text("@"+convo.otherUsername).font(.headline)
                            Text("You").bold().font(.caption).foregroundColor(.secondary) + Text(" started this conversation on October 19, 2024").font(.caption).foregroundColor(.secondary)
                        }
                        ForEach(messages) { message in
                            HStack {
                                if message.type == 0 {
                                    RightMessage(message: message.content)
                                } else {
                                    LeftMessage(message: message.content)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                            .id(message.id)
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                    .onChange(of: focued) { _ in
                        scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            HStack {
                TextField(text: $message, prompt: Text("Write a message...")) {
                    EmptyView()
                }.focused($focued)
                Spacer()
                Button {
                    messages.append(Message(content: message, type: 0))
                    message = ""
                } label: {
                    Image(systemName: "paperplane.circle.fill").font(.largeTitle)
                }
                
            }.padding(.horizontal).padding(.vertical, 5).background(Color.secondary.background(.black).opacity(0.5)).clipShape(Capsule()).padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    //KFImage(URL(string: convo.otherUserImage)).resizable().frame(width: 30, height: 30).clipShape(Circle())
                    Text(convo.otherUser).bold()
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .padding(.vertical, 4)
            }
        })
    }
}

struct LeftMessage: View {
    var message: String
    var body: some View {
        HStack {
            Text(message).padding().background(Color.secondary).clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 7.5, bottomTrailingRadius: 20, topTrailingRadius: 20))
            Spacer()
        }
    }
}

struct RightMessage: View {
    var message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message).padding().background(Color.accent).clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 7.5, topTrailingRadius: 20))
        }
    }
}

struct Message: Identifiable {
    var id: UUID = UUID()
    var content: String
    var type: Int
}
